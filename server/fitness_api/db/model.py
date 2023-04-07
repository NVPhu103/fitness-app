from datetime import date as _date
from uuid import uuid4, UUID

from sqlalchemy import (
    CheckConstraint,
    Column,
    Enum,
    ForeignKey,
    Integer,
    String,
    DateTime,
    UniqueConstraint,
    Index,
    Boolean,
    DATE as SqlDATE
)
from sqlalchemy.dialects.postgresql import UUID as SqlUUID
from sqlalchemy.ext.hybrid import hybrid_property
from fitness_api.config import declarative_base, BaseMixin, MetaData
from fitness_api.schemas.food import FoodUnit, FoodStatus

from sqlalchemy.orm import relationship, backref

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


class Food(BaseModel):
    id: UUID = Column(
        SqlUUID(as_uuid=True),
        default=uuid4,
        nullable=False,
        primary_key=True,
        index=True,
    )
    name: str = Column(String, nullable=False, index=True, unique=True)
    unit: FoodUnit = Column(Enum(FoodUnit), default=FoodUnit.GRAM, nullable=False)
    calories: int = Column(Integer, nullable=False)
    status: FoodStatus = Column(
        Enum(FoodStatus), default=FoodStatus.ACTIVE, nullable=False
    )

    __table_args__ = (CheckConstraint(calories > 0),)


class Diary(BaseModel):
    id: UUID = Column(
        SqlUUID(as_uuid=True),
        default=uuid4,
        nullable=False,
        primary_key=True,
        index=True,
    )
    user_id: UUID = Column(SqlUUID(as_uuid=True), nullable=False, index=True)
    date: _date = Column(SqlDATE, default=_date.today(), index=True)
    breakfast_id: UUID = Column(SqlUUID(as_uuid=True), nullable=False)
    lunch_id: UUID = Column(SqlUUID(as_uuid=True), nullable=False)
    dining_id: UUID = Column(SqlUUID(as_uuid=True), nullable=False)
    daily_calories_goal: int = Column(Integer, default=1500)
    daily_calories_total: int = Column(Integer, default=0)


class FoodDaily(BaseModel):
    id: UUID = Column(
        SqlUUID(as_uuid=True),
        nullable=False,
        primary_key=True,
        index=True,
    )
    meal_id: UUID = Column(SqlUUID(as_uuid=True), nullable=False, index=True)
    food_id: UUID = Column(
        SqlUUID(as_uuid=True), ForeignKey("food.id"), nullable=False, index=True
    )
    food: Food = relationship("Food", backref=backref("fooddailys", lazy="selectin"))
    quantity: int = Column(
        Integer,
        default=1,
    )

    __table_args__ = (
        CheckConstraint(quantity > 1),
        UniqueConstraint(meal_id, food_id),
        Index(meal_id, food_id),
    )
