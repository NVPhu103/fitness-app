from typing import Optional
from datetime import date as _date
from .config import BaseModelWithConfig
from pydantic import Field
from uuid import UUID


class BaseDiaryModel(BaseModelWithConfig):
    user_id: UUID = Field(..., title="User ID", alias="userId")
    date: _date = Field(..., title="the journaling date")


class PostDiaryModel(BaseDiaryModel):
    ...


class PatchDiaryModel(BaseModelWithConfig):
    maximum_calorie_intake: Optional[int] = Field(
        None,
        title="The maximum amount of calories that a user can take in per day",
        alias="maximumCalorieIntake",
    )
    total_calorie_intake: Optional[int] = Field(
        None,
        title="Calories that the user has taken in during the day",
        alias="totalCaloriesIntake",
    )


class DiaryModel(BaseDiaryModel):
    id: UUID = Field(..., title="Diary ID")
    breakfast_id: UUID = Field(..., alias="breakfastId", title="one of the meals")
    lunch_id: UUID = Field(..., alias="lunchId", title="one of the meals")
    dining_id: UUID = Field(..., alias="diningId", title="one of the meals")
    maximum_calorie_intake: int = Field(
        ...,
        title="The maximum amount of calories that a user can take in per day",
        alias="maximumCalorieIntake",
    )
    total_calorie_intake: int = Field(
        ...,
        title="Calories that the user has taken in during the day",
        alias="totalCaloriesIntake",
    )
