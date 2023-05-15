from __future__ import annotations
from typing import NamedTuple, Dict
import logging
import hashlib
import uuid
from collections import deque
from typing import Any, List, Optional, Union

import sqlalchemy as sa
from sqlalchemy import inspect, func, cast
from sqlalchemy.ext.hybrid import hybrid_method
from sqlalchemy.ext.asyncio import AsyncSession, AsyncConnection
import sqlalchemy.ext.declarative
import sqlalchemy.orm
import sqlalchemy.sql.expression
import sqlalchemy.sql.selectable
from sqlalchemy.future import select
from sqlalchemy.dialects.postgresql import UUID
from fitness_api.config import BaseMixin as Model

logger = logging.getLogger(__name__)

SelectType = sqlalchemy.sql.selectable.Select
BaseType = Union[sa.Table, sa.ext.declarative.DeclarativeMeta]
IndexableType = Union[sa.Column, sa.ForeignKeyConstraint, sa.UniqueConstraint]


def paginate_query(
    query: "SelectType", page: Optional[int] = None, size: Optional[int] = None
) -> "SelectType":
    logger.debug(f"Paginating query with page={page}, size={size}")

    query = make_order_by_deterministic(query)
    if page is None or size is None:
        return query

    query = _set_offset(query, page, size)
    query = _set_limit(query, size)
    return query


def _set_offset(query: "SelectType", page: int, size: int) -> "SelectType":
    offset = _calculate_offset(page, size)

    current_offset = getattr(query, "_offset", None)
    if current_offset is None:
        logger.debug(f"Setting offset to {offset}")
        query = query.offset(offset)
    else:
        logger.debug(f"Honoring existing offset of {current_offset}")

    return query


def _set_limit(query: "SelectType", size: int) -> "SelectType":
    current_limit = getattr(query, "_limit", None)
    if current_limit is None:
        logger.debug(f"Setting limit to {size}")
        query = query.limit(size)
    else:
        logger.debug(f"Honoring existing limit of {current_limit}")

    return query


def count_query(
    query: "SelectType", from_base: Optional["BaseType"] = None
) -> "SelectType":
    if from_base:
        pk = _pk_from_base(from_base).pop(0)
        tables = [pk.table]
        count_func = sa.func.count(pk.distinct())
    else:
        tables = _stmt_tables(query)
        count_func = sa.func.count()

    return (
        query.select_from(*tables)
        .with_only_columns([count_func])
        .order_by(None)
        .limit(None)
        .offset(None)
    )


def make_order_by_deterministic(query: "SelectType") -> "SelectType":
    """Taken from sqlalchemy_utils.

    Make query order by deterministic (if it isn't already). Order by is
    considered deterministic if it contains column that is unique index (
    either it is a primary key or has a unique index). Many times it is design
    flaw to order by queries in nondeterministic manner.
    """
    order_by_func = sa.asc

    order_by_clauses = getattr(query, "_order_by_clauses", None)
    if not order_by_clauses:
        column = None
    else:
        order_by = order_by_clauses[0]
        if isinstance(order_by, sa.sql.elements._label_reference):
            order_by = order_by.element
        if isinstance(order_by, sa.sql.expression.UnaryExpression):  # type: ignore
            if order_by.modifier == sa.sql.operators.desc_op:
                order_by_func = sa.desc
            else:
                order_by_func = sa.asc
            column = list(order_by.get_children())[0]
        else:
            column = order_by

    # Skip queries that are ordered by an already deterministic column
    if isinstance(column, sa.Column):
        try:
            if has_unique_index(column):
                return query
        except TypeError:
            pass

    tables = _stmt_tables(query)
    for table in tables:
        pkey_columns = list(table.primary_key.columns.values())
        if pkey_columns:
            query = query.order_by(*(order_by_func(c) for c in pkey_columns))
            break
    else:
        raise ValueError("No deterministic ordering method found.")
    return query


def has_unique_index(column_or_constraint: "IndexableType") -> bool:
    """Taken from sqlalchemy_utils

    Return whether or not given column or given foreign key constraint has a
    unique index.

    A column has a unique index if it has a single column primary key index or
    it has a single column UniqueConstraint.

    A foreign key constraint has a unique index if the columns of the
    constraint are the same as the columns of table primary key or the coluns
    of any unique index or any unique constraint of the given table.

    """
    table = column_or_constraint.table
    if not isinstance(table, sa.Table):
        raise TypeError(
            f"Only columns belonging to Table objects are supported. Given "
            f"column belongs to {table}."
        )
    primary_keys = list(table.primary_key.columns.values())

    columns: List[IndexableType]
    if isinstance(column_or_constraint, sa.ForeignKeyConstraint):
        columns = list(column_or_constraint.columns.values())
    else:
        columns = [column_or_constraint]

    return (
        (columns == primary_keys)
        or any(
            columns == list(constraint.columns.values())
            for constraint in table.constraints
            if isinstance(constraint, sa.sql.schema.UniqueConstraint)
        )
        or any(
            columns == list(index.columns.values())
            for index in table.indexes
            if index.unique
        )
    )


def _stmt_tables(stmt: "SelectType") -> List[sa.Table]:
    found = []

    queue = deque(stmt.froms)
    while queue:
        from_clause = queue.popleft()
        if isinstance(from_clause, sa.Table) and not from_clause in found:
            found.append(from_clause)
        elif isinstance(from_clause, sa.orm.util._ORMJoin):
            queue.append(from_clause.left)
            queue.append(from_clause.right)

    return found


def _pk_from_base(base: "BaseType") -> List[sa.Column[Any]]:
    table = getattr(base, "__mapper__", base)
    return list(table.primary_key)


def _calculate_offset(page: int, size: int) -> int:
    page = max(page, 1)
    size = max(size, 1)

    return (page - 1) * size


class UniqueConstraint(NamedTuple):
    name: str
    column_names: List[str]


class UniqueConstraintViolation(NamedTuple):
    constraint: UniqueConstraint
    conflict: Model  # The conflicting record


class Inspection:

    __instance = None

    @staticmethod
    def get_instance() -> Inspection:
        if Inspection.__instance == None:
            Inspection()
        return Inspection.__instance  # type: ignore

    def __init__(self) -> None:
        if Inspection.__instance != None:
            raise Exception("This is singleton class. Use get_instance() instead")
        Inspection.__instance = self

    def _get_constraints(
        self, engine: AsyncConnection, model: Model
    ) -> list[dict[str, str]]:
        isp = inspect(engine)
        constraints = isp.get_unique_constraints(model.__table__.name, model.__table__.schema)  # type: ignore
        return constraints  # type: ignore

    async def get_integrity_violations(
        self, record: dict[str, str], session: AsyncSession, model: Model
    ) -> Union[list[UniqueConstraintViolation], None]:
        conn = await session.connection()
        constraints = await conn.run_sync(self._get_constraints, model)

        violations = []
        for constraint in constraints:
            stmt = select(model)
            for column in constraint["column_names"]:
                stmt = stmt.where(getattr(model, column) == record.get(column))
            result = await session.execute(stmt)
            conflict = result.scalars().first()

            if conflict:
                unique_constraint = UniqueConstraint(**constraint)
                violation = UniqueConstraintViolation(
                    constraint=unique_constraint, conflict=conflict
                )
                violations.append(violation)

        return violations or None


async def get_integrity_error_message(
    data: Dict[str, str], session: AsyncSession, model: Model
) -> str:
    inspector = Inspection.get_instance()
    violations = await inspector.get_integrity_violations(data, session, model)
    message = ""
    if violations is None:
        message = "Conflicts discovered."
    else:
        columns = set()
        for v in violations:
            for column in v.constraint.column_names:
                columns.add(column)
        error_str = ", ".join(columns)
        message = f"Conflicts discovered in the following fields {error_str}"
    return message


class Md5Indexing:
    """
    Provide md5::UUID comparisons against md5::UUID index expressions.

    To use this as a mixin, create a hybrid_property for your MD5::UUID column:

    ```python
    class Division(Base, Md5Indexing):
        legacy_account_code = Column(String)

        @hybrid_property
        def legacy_account_code_md5(self):
            return self.md5_index(self.legacy_account_code)

        @legacy_account_code_md5.expression
        def legacy_account_code_md5(cls):
            return cls.md5_index(cls.legacy_account_code)

    query = Division.query.filter(Division.legacy_account_code_md5 == Division.md5_index("bos2020"))
    ```

    In this example the SQL generated is:
    ```sql
    SELECT division.*
    FROM division
    WHERE CAST(md5(lower(division.legacy_account_code)) AS UUID) = CAST(md5(lower(%(lower_1)s)) AS UUID)
    ```

    For this to be an effective way to avoid sequential scans in favor of bitmap
    or index scans, the database field must have the following index applied:

    For column "legacy_account_code":
    ```python
    __table_args__ = (
        Index("ix_legacy_account_code_uuid", Md5Indexing.md5_index(legacy_account_code)),
    )
    ```
    ```sql
    CREATE INDEX CONCURRENTLY ON division (CAST(md5(LOWER(legacy_account_code)) AS uuid));
    ```
    """

    @hybrid_method
    def md5_index(self, value):
        md5 = hashlib.md5(value.lower().encode())
        return uuid.UUID(md5.hexdigest())

    @md5_index.expression  # type: ignore
    def md5_index(self, value):
        return cast(func.md5(func.lower(value)), UUID)
