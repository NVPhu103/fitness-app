from enum import Enum
from typing import List, Union, Callable, Type, Optional, Dict, Any
from uuid import UUID
import logging
from fastapi import Query
from pydantic import BaseModel as PydanticBaseModel
from pydantic.dataclasses import dataclass
from sqlalchemy import or_, and_, cast, select, inspect
from sqlalchemy.orm.attributes import InstrumentedAttribute
from sqlalchemy.orm.decl_api import DeclarativeMeta
from sqlalchemy.sql.elements import BooleanClauseList
from sqlalchemy.sql.selectable import Select as Selectable
from sqlalchemy.sql.visitors import Visitable
from sqlalchemy.types import String
from sqlalchemy.dialects.postgresql import UUID as sqlUUID

from fitness_api.db.model import BaseModel

logger = logging.getLogger(__name__)

QSTRING_SYNTAX_HELP = ""
INVALID_SEARCH_PARAM = "a84c062c"  # Invalid search param


class OperatorEnum(str, Enum):
    AND = "and"
    OR = "or"

    @classmethod
    def _missing_(cls, value: Any) -> Any:
        for member in cls:
            if member.value.lower() == value.lower():
                return member


class SearcherParamsConfig:
    allow_population_by_field_name = True


@dataclass(frozen=False, config=SearcherParamsConfig)
class SearcherParams:
    q: Union[str, None] = Query(
        None,
        description=f"Search term.  More search feature documentation is available [here]({QSTRING_SYNTAX_HELP})",
    )

    df: Union[str, None] = Query(None, description="Default field to search.")
    operator: Union[OperatorEnum, None] = Query(
        None,
        description="Operator used when combining multiple search terms.",
        alias="default_operator",
    )

    sort: Union[str, None] = Query(None, description="Sort order for search results.")


class Searcher:
    def __init__(
        self,
        params: SearcherParams,
        model: Type[BaseModel],  # type: ignore
        schema: Type[PydanticBaseModel],
        df_field: str,
    ) -> None:
        self.params = params
        self.model = model
        self.schema = schema
        self.base_query = select(self.model)
        if not self.params.df:
            self.params.df = df_field
        if not self.params.operator:
            self.params.operator = OperatorEnum.OR
        else:
            self.params.operator = self.params.operator

    @property
    def operator(self) -> Callable[..., Visitable]:
        if self.params.operator == OperatorEnum.OR:
            return or_
        else:
            return and_

    async def _map_field(self, field: str) -> str:
        for model_key, model_field in self.schema.__fields__.items():

            if model_field.alias:
                db_key = model_field.alias
            else:
                db_key = model_key

            (db_key, *rem) = db_key.split(".")

            if field.lower() in map(str.lower, (model_key, db_key)):
                field = model_key
                break

        return field

    async def _parse_term(self) -> List[Visitable]:
        filters: List[Visitable] = []

        if not self.params.q:
            return filters

        terms = self.params.q.split("+")

        for i, term in enumerate(terms):
            term = term.strip()
            parts = term.split(":")
            if len(parts) > 2:
                raise ValueError(INVALID_SEARCH_PARAM, f"Invalid search term {term}")
            if len(parts) == 1:
                if self.params.df:
                    parts.insert(0, self.params.df)
                else:
                    raise ValueError(
                        INVALID_SEARCH_PARAM, f"Invalid search term {term}"
                    )
            parts[0] = await self._map_field(parts[0])
            if not hasattr(self.model, f"{parts[0]}"):
                raise ValueError(
                    INVALID_SEARCH_PARAM, f"Invalid search term: key={parts[0]}"
                )
            if subtable_info := await self._jsonb_subtable_info(parts[0]):
                if not parts[1]:
                    # In case that the operator is OR, or search with only one jsonb column equal to null,
                    # this searcher returns all rows
                    if self.operator == or_ or (
                        len(filters) == 0 and i >= len(terms) - 1
                    ):
                        return []
                    continue
                filters.append(
                    await self._form_jsonb_search_filter(
                        subtable_info["submodel"], parts[1]
                    )
                )
            elif parts[0] in self._exact_match_only_uuid_fields():
                attr = getattr(self.model, parts[0])
                logger.warning(
                    f"Intercepted q-string search for {parts[0]}, replacing with exact match."
                )
                squery = self._validate_uuid(parts[1], self.model.__name__)
                filters.append(attr == squery)
            else:
                attr = cast(getattr(self.model, parts[0]), String)
                if parts[1]:
                    filters.append(attr.ilike(f"%{parts[1]}%"))
                else:
                    filters.append(attr.is_(None))

        return filters

    async def _order(self) -> None:
        if not self.params.sort:
            return

        parts = self.params.sort.split(":")
        if len(parts) > 2:
            raise ValueError(
                "Invalid sort param format. fieldName, or fieldName:asc/fieldName:desc."
            )
        order = "asc"
        if len(parts) == 2:
            order = parts[1].lower()
        if order not in ["asc", "desc"]:
            raise ValueError(
                "Invalid sort param format. fieldName, or fieldName:asc/fieldName:desc."
            )

        field = parts[0]
        field = await self._map_field(field)
        if not hasattr(self.model, field):
            raise ValueError(f"Invalid sort term: {field}")

        order_clause = getattr(getattr(self.model, field), order)
        self.base_query = self.base_query.order_by(order_clause())

    async def _jsonb_subtable_info(self, field: str) -> Optional[Dict[Any, Any]]:
        """
        This function calls 'jsonb_subtable_info()' function of the main model.
        It returns a dictionary of referent field and submodel if the field was jsonb and now is its own table,
        return None otherwise.
        return example:
            {"ref": cls.address, "submodel": Address}
        """
        if self.model:
            subtable_info = getattr(self.model, "jsonb_subtable_info", None)
            if callable(subtable_info):
                return self.model.jsonb_subtable_info(field)  # type: ignore
        return None

    async def _form_jsonb_search_filter(
        self, submodel: DeclarativeMeta, squery: str
    ) -> BooleanClauseList:  # type: ignore
        """
        This function produces a filter of searching on a sub-table that mimic searching on a jsonb column
        """
        filters = []

        joint_tables = [ent[0] for ent in self.base_query._setup_joins]  # type: ignore
        if submodel.__table__ not in joint_tables:  # type: ignore
            self.base_query = self.base_query.join(submodel)

        fields = inspect(submodel).all_orm_descriptors.keys()
        if "id" in fields:
            fields.remove("id")

        for field in fields:
            attr = cast(getattr(submodel, field), String)
            if squery:
                filters.append(attr.ilike(f"%{squery}%"))
            else:
                filters.append(attr.is_(None))

        return or_(*filters)

    async def apply_searcher(self, query: Optional[Selectable] = None) -> Selectable:
        if query is not None:
            self.base_query = query
        else:
            self.base_query = select(self.model)
        if not isinstance(self.base_query, Selectable):
            raise ValueError("Invalid base query!")

        await self._order()
        if self.params.q:
            filters = await self._parse_term()
            filter_expressions = self.operator(*filters)
            self.base_query = self.base_query.filter(filter_expressions)

        return self.base_query

    def _exact_match_only_uuid_fields(self) -> List[str]:
        if not self.model:
            return []
        uuid_columns = [col.name for col in self.model.__table__.columns if type(col.type) is sqlUUID]  # type: ignore
        return uuid_columns

    def _validate_uuid(self, id: Union[str, UUID], type: str) -> UUID:
        if isinstance(id, UUID):
            return id
        try:
            return UUID(id)
        except Exception:
            raise ValueError(f"Invalid {type} id: {id}")
