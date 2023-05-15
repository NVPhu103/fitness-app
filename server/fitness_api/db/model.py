from datetime import date as _date
from uuid import uuid4, UUID

from sqlalchemy import (
    CheckConstraint,
    Column,
    Enum,
    ForeignKey,
    Integer,
    Float,
    String,
    DateTime,
    UniqueConstraint,
    Index,
    Boolean,
    DATE as SqlDATE,
)
from sqlalchemy.dialects.postgresql import UUID as SqlUUID
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.orm import relationship, backref
from sqlalchemy.types import Enum

from fitness_api.config import declarative_base, BaseMixin, MetaData
from fitness_api.schemas.food import FoodUnit, FoodStatus
from fitness_api.schemas.user_profile import UserProfileStatus, UserProfileActivityLevel, UserProfileGender
from fitness_api.schemas.user import UserRole
from fitness_api.schemas.exercise import ExerciseType, BurningType

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
    _email: str = Column(String, name="email", nullable=False)
    hashed_password: str = Column(String, nullable=False)
    is_active: bool = Column(Boolean, default=True)
    _role: UserRole = Column(
        Enum(UserRole), name="role", nullable=False, default=UserRole.USER.value
    )

    @hybrid_property
    def email(self) -> str:
        return self._email

    @email.setter
    def email(self, value: str) -> None:
        self._email = value.lower()

    @hybrid_property
    def role(self) -> UserRole:
        return self._role

    @role.setter
    def role(self, value: UserRole) -> None:
        self._role = UserRole.USER.value
        if value == UserRole.ADMIN.value:
            if self._email.endswith("@admin.com"):
                self._role = UserRole.ADMIN.value

    __table_args__ = (UniqueConstraint(_email),)


class UserProfile(BaseModel):
    id: UUID = Column(
        SqlUUID(as_uuid=True),
        default=uuid4,
        nullable=False,
        primary_key=True,
        index=True,
    )
    user_id: UUID = Column(
        SqlUUID(as_uuid=True),
        ForeignKey("user.id"),
        nullable=False,
    )
    gender: UserProfileGender = Column(Enum(UserProfileGender), nullable=False)
    current_weight: float = Column(
        Float,
        CheckConstraint("current_weight > 0"),
        nullable=False,
    )
    desired_weight: float = Column(
        Float, CheckConstraint("desired_weight > 0"), nullable=False
    )
    height: float = Column(Float, CheckConstraint("height > 0"), nullable=False)
    _year_of_birth: int = Column(Integer, nullable=False)
    status: UserProfileStatus = Column(
        Enum(UserProfileStatus), nullable=False, default=UserProfileStatus.ACTIVE.value
    )
    activity_level: UserProfileActivityLevel = Column(
        Enum(UserProfileActivityLevel), nullable=False
    )
    maximum_calorie_intake: int = Column(Integer, default=2000, nullable=False)

    @hybrid_property
    def year_of_birth(self) -> int:
        return self._year_of_birth

    @year_of_birth.setter
    def year_of_birth(self, value: int) -> None:
        if (value >= 1950) and (value < (_date.today().year - 5)):
            self._year_of_birth = value

    __table_args__ = (
        CheckConstraint(current_weight != desired_weight),
        CheckConstraint(maximum_calorie_intake >= 1000),
    )


class Food(BaseModel):
    id: UUID = Column(
        SqlUUID(as_uuid=True),
        default=uuid4,
        nullable=False,
        primary_key=True,
        index=True,
    )
    name: str = Column(String, nullable=False, index=True, unique=True)
    unit: FoodUnit = Column(Enum(FoodUnit), default=FoodUnit.GRAM.value, nullable=False)
    calories: int = Column(Integer, nullable=False)
    status: FoodStatus = Column(
        Enum(FoodStatus), default=FoodStatus.ACTIVE.value, nullable=False
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
    user_id: UUID = Column(
        SqlUUID(as_uuid=True), ForeignKey("user.id"), nullable=False, index=True
    )
    date: _date = Column(SqlDATE, default=_date.today(), index=True)
    breakfast_id: UUID = Column(SqlUUID(as_uuid=True), default=uuid4, nullable=False)
    lunch_id: UUID = Column(SqlUUID(as_uuid=True), default=uuid4, nullable=False)
    dining_id: UUID = Column(SqlUUID(as_uuid=True), default=uuid4, nullable=False)
    maximum_calorie_intake: int = Column(Integer, default=2000)
    total_calorie_intake: int = Column(Integer, default=0)

    __table_args__ = (
        CheckConstraint(maximum_calorie_intake >= 1000),
        UniqueConstraint(user_id, date),
    )


class FoodDiary(BaseModel):
    id: UUID = Column(
        SqlUUID(as_uuid=True),
        default=uuid4,
        nullable=False,
        primary_key=True,
        index=True,
    )
    meal_id: UUID = Column(SqlUUID(as_uuid=True), nullable=False, index=True)
    food_id: UUID = Column(
        SqlUUID(as_uuid=True), ForeignKey("food.id"), nullable=False, index=True
    )
    quantity: int = Column(
        Integer,
        default=1,
    )
    _total_calories: int = Column(Integer, name="total_calories", nullable=False)

    @hybrid_property
    def total_calories(self) -> int:
        return self._total_calories

    @total_calories.setter
    def total_calories(self) -> None:
        self._total_calories = self.food.calories * self.quantity

    __table_args__ = (
        CheckConstraint(quantity > 1),
        UniqueConstraint(meal_id, food_id),
        Index(meal_id, food_id),
    )


class Exercise(BaseModel):
    id: UUID = Column(
        SqlUUID(as_uuid=True),
        default=uuid4,
        nullable=False,
        primary_key=True,
        index=True,
    )
    name: str = Column(String, nullable=False, index=True, unique=True)
    _exercise_type: ExerciseType = Column(Enum(ExerciseType), default=ExerciseType.CARDIO.value, name="exercise_type")
    description: str = Column(String, nullable=True,)
    _burning_type: BurningType = Column(Enum(BurningType), nullable=False, name="burning_type")
    burned_calories: int = Column(Integer, CheckConstraint("burned_calories > 0"), nullable=False, )

    @hybrid_property
    def exercise_type(self) -> ExerciseType:
        return self._exercise_type

    @exercise_type.setter
    def exercise_type(self, value: ExerciseType) -> None:
        self._exercise_type = value.value

    @hybrid_property
    def burning_type(self) -> BurningType:
        return self._burning_type

    @burning_type.setter
    def burning_type(self, value: BurningType) -> None:
        self._burning_type = value.value
    