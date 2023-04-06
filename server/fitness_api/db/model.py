from datetime import datetime
from uuid import uuid4, UUID

from sqlalchemy import Column, String, DateTime, UniqueConstraint, Index, Boolean
from sqlalchemy.dialects.postgresql import UUID as SqlUUID
from sqlalchemy.ext.hybrid import hybrid_property
from fitness_api.config import declarative_base, BaseMixin, MetaData

BaseModel = declarative_base(metadata=MetaData, cls=BaseMixin)

class User(BaseModel):
    id: UUID = Column(
        SqlUUID(as_uuid=True),
        default=uuid4,
        nullable=False,
        primary_key=True,
        index=True,
    )
    username: str = Column(String, nullable=False, unique=True)
    hashed_password: str = Column(String, nullable=False)
    _email: str = Column(String, name="email", nullable=False)
    is_active: bool = Column(Boolean, default=True)

    @hybrid_property
    def email(self) -> str:
        return self._email

    @email.setter
    def email(self, value: str) -> None:
        self._email = value.lower()

    __table_args__ = (UniqueConstraint(username),)
