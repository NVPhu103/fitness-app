from pydantic.networks import PostgresDsn


from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.asyncio import AsyncSession, AsyncEngine, create_async_engine
from sqlalchemy.orm import declared_attr, declarative_mixin, declarative_base
from sqlalchemy import MetaData as _MetaData

from .helpers import camel_to_snake_case

APPLICATION_TITLE = "FITNESS API"
DATABASE_URI: PostgresDsn = "postgresql+asyncpg://postgres:password@localhost:5432/fitness"

async_engine: AsyncEngine = create_async_engine(
    DATABASE_URI,
    echo=True,
    future=True,
)

async_session_factory = sessionmaker(
    bind=async_engine, 
    class_=AsyncSession,
    expire_on_commit=False,
)

@declarative_mixin
class BaseMixin:
    @declared_attr
    def __tablename__(cls) -> str:
        return camel_to_snake_case(cls.__name__)  # type: ignore

    def apply_update(self, **kwargs: object) -> None:
        """Apply a set of changes to an instance.

        Eg:
            obj.apply_update(**patch.dict(exclude_unset=True))
        """
        for key, value in kwargs.items():
            setattr(self, key, value)


metadata_config = {
    "naming_convention": {
        "ix": "ix_%(column_0_label)s",
        "uq": "uq_%(table_name)s_%(column_0_name)s",
        "ck": "ck_%(table_name)s_%(constraint_name)s",
        "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
        "pk": "pk_%(table_name)s",
    }
}

MetaData = _MetaData(**metadata_config)


