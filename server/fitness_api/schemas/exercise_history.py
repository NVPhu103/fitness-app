from typing import List, Optional
from datetime import date as _date
from .config import BaseModelWithConfig
from pydantic import Field
from uuid import UUID
from .exercise import ExerciseModel


class BaseExerciseHistoryModel(BaseModelWithConfig):
    user_id: UUID = Field(..., alias="userId")
    exercise_id: UUID = Field(..., alias="exerciseId")


class PostExerciseHistoryModel(BaseExerciseHistoryModel):
    ...


class PatchExerciseHistoryModel(BaseModelWithConfig):
    number_of_uses: int = Field(None, alias="numberOfUses")


class ExerciseHistoryModel(BaseExerciseHistoryModel):
    id: UUID = Field(..., title="Food history ID")
    number_of_uses: int = Field(..., alias="numberOfUses")
    exercise: ExerciseModel = Field(..., title="exercise information")
