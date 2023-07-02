import enum

from typing import Optional

from .config import BaseModelWithConfig
from pydantic import Field, validator
from uuid import UUID


class ExerciseType(enum.Enum):
    CARDIO = "CARDIO"
    STRENGTH = "STRENGTH"


class BurningType(str, enum.Enum):
    CPH = "CALORIES_PER_HOUR"
    CPS = "CALORIES_PER_SET"


class ExerciseStatus(enum.Enum):
    ACTIVE = "ACTIVE"
    INACTIVE = "INACTIVE"


class BaseExerciseModel(BaseModelWithConfig):
    name: str = Field(..., title="Exercise name")
    exercise_type: ExerciseType = Field(
        ..., title="Exercise Type", alias="exerciseType"
    )
    description: str = Field(..., title="Description of the exercise")
    burning_type: BurningType = Field(
        ..., title="Type that calories is burned in the exercise", alias="burningType"
    )
    burned_calories: int = Field(
        ..., title="Calories is burned in the exercise", alias="burnedCalories"
    )


class PostExerciseModel(BaseExerciseModel):
    class Config(BaseModelWithConfig.Config):
        schema_extra = {
            "example": {
                "name": "Running, 10.7 kph (5.6 min per km)",
                "exerciseType": ExerciseType.CARDIO.value,
                "description": "You run 10.7 kilometers per hour",
                "burningType": BurningType.CPH.value,
                "burnedCalories": 300,
            }
        }


class PatchExerciseModel(BaseModelWithConfig):
    name: str = Field(None, title="Exercise name")
    description: str = Field(None, title="Description of the exercise")
    burned_calories: int = Field(
        None, title="Calories is burned in the exercise", alias="burnedCalories"
    )
    status: ExerciseStatus = Field(
        None,
    )

    class Config(BaseModelWithConfig.Config):
        schema_extra = {
            "example": {
                "name": "Running, 14.5 kph (4.1 min per km)",
                "description": "edit descriptions",
                "burned_calories": 300,
                "status": ExerciseStatus.ACTIVE.value,
            }
        }


class ExerciseModel(BaseExerciseModel):
    id: UUID = Field(..., title="Exercise ID")
    status: ExerciseStatus = Field(
        ...,
    )

    class Config(BaseModelWithConfig.Config):
        schema_extra = {
            "example": {
                "id": "b65992db-bb4c-43da-8118-5f9696a8c597",
                "name": "Running, 10.7 kph (5.6 min per km)",
                "exerciseType": ExerciseType.CARDIO.value,
                "description": "You run 10.7 kilometers per hour",
                "burningType": BurningType.CPH.value,
                "burnedCalories": 300,
                "status": ExerciseStatus.ACTIVE.value,
            }
        }
