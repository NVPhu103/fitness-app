from typing import Optional
from datetime import date as _date
from .config import BaseModelWithConfig
from pydantic import Field
from uuid import UUID

from fitness_api.schemas.food import FoodModel


class BaseFoodDiaryModel(BaseModelWithConfig):
    ...


class PostFoodDiaryModel(BaseFoodDiaryModel):
    meal_id: UUID = Field(
        ..., title="one of breakfast_id, lunch_id, dining_id", alias="mealId"
    )
    food_id: UUID = Field(..., title="the food id", alias="foodId")
    quantity: Optional[int] = Field(1, title="quantities of the food")


class PatchFoodDiaryModel(BaseFoodDiaryModel):
    quantity: Optional[int] = Field(None, title="quantities of the food")


class FoodDiaryModel(BaseFoodDiaryModel):
    id: UUID = Field(..., title="Diary ID")
    food: Optional[FoodModel] = Field(None, title="The food details")
    meal_id: UUID = Field(
        ..., title="one of breakfast_id, lunch_id, dining_id", alias="mealId"
    )
    food_id: UUID = Field(..., title="the food id", alias="foodId")
    quantity: int = Field(..., title="quantities of the food")
