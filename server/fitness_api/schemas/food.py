import enum
from .config import BaseModelWithConfig
from pydantic import Field
from uuid import UUID

class FoodUnit(enum.Enum):
    BOWL = "bowl"
    CUP = "cup"
    GRAM = "gram"


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
                "unit" : "gram"
            }
        }


class FoodModel(BaseFoodModel):
    id: UUID = Field(..., title="ID")
    class Config(BaseFoodModel.Config):
        schema_extra= {
            "example": {
                "id": "aae992db-bb4c-43da-8118-5f9696a8b684",
                "name": "rice",
                "calories": 300,
                "unit" : "gram"
            }
        }
