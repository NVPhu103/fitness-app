from typing import List, Optional
from datetime import date as _date
from .config import BaseModelWithConfig
from pydantic import Field
from uuid import UUID
from fitness_api.schemas.diary import DiaryModel
from fitness_api.schemas.exercise import ExerciseModel


class BaseExerciseDiaryModel(BaseModelWithConfig):
    exercise_id: UUID = Field(..., alias="exerciseId")
    diary_id: UUID = Field(..., alias="diaryId")
    practice_time: int = Field(..., alias="practiceTime")


class PostExerciseDiaryModel(BaseExerciseDiaryModel):
    ...


class PatchExerciseDiaryModel(BaseModelWithConfig):
    practice_time: int = Field(..., alias="practiceTime")


class ExerciseDiaryModel(BaseExerciseDiaryModel):
    id: UUID = Field(
        ...,
    )
    exercise: ExerciseModel = Field(
        ...,
    )
    burned_calories: int = Field(..., alias="burnedCalories")


class ExerciseDiaryWithDiaryModel(BaseExerciseDiaryModel):
    id: UUID = Field(
        ...,
    )
    burned_calories: int = Field(..., alias="burnedCalories")
    diary: DiaryModel = Field(None, title="diary of user")
