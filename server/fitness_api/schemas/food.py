import enum
from typing import Optional
from .config import BaseModelWithConfig
from pydantic import Field
from uuid import UUID

class FoodUnit(enum.Enum):
    BOWL = "a bowl"
    CUP = "a cup"
    GRAM = "100 gram"

class FoodStatus(enum.Enum):
    ACTIVE = "ACTIVE"
    INACTIVE = "INACTIVE"

class BaseFoodModel(BaseModelWithConfig):
    name: str = Field(..., title="Food name")
    calories: int = Field(..., title="The calories of the food")
    unit: FoodUnit = Field(..., title="the unit of the food")


class PostFoodModel(BaseFoodModel):
    class Config(BaseFoodModel.Config):
        schema_extra= {
            "example": {
                "name": "rice",
                "calories": 300,
                "unit" : "100 gram"
            }
        }

class PatchFoodModel(BaseModelWithConfig):
    name: Optional[str] = Field(..., title="Food name")
    calories: Optional[int] = Field(..., title="The calories of the food")
    unit: Optional[FoodUnit] = Field(..., title="the unit of the food")
    status: Optional[FoodStatus] = Field(..., title="Status of the food")

class FoodModel(BaseFoodModel):
    id: UUID = Field(..., title="ID")
    status: FoodStatus = Field(..., title="Status of the food")
    class Config(BaseFoodModel.Config):
        schema_extra= {
            "example": {
                "id": "aae992db-bb4c-43da-8118-5f9696a8b684",
                "name": "rice",
                "calories": 300,
                "unit" : "100 gram",
                "status": FoodStatus.ACTIVE
            }
        }
