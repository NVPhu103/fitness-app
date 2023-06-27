from typing import List, Optional
from datetime import date as _date
from .config import BaseModelWithConfig
from pydantic import Field
from uuid import UUID
from .food import FoodModel


class BaseFoodHistoryModel(BaseModelWithConfig):
    user_id: UUID = Field(..., alias="userId")
    food_id: UUID = Field(..., alias="foodId")


class PostFoodHistoryModel(BaseFoodHistoryModel):
    ...


class PatchFoodHistoryModel(BaseModelWithConfig):
    number_of_uses: int = Field(..., alias="numberOfUses")


class FoodHistoryModel(BaseFoodHistoryModel):
    id: UUID = Field(..., title="Food history ID")
    number_of_uses: int = Field(..., alias="numberOfUses")
    food: FoodModel = Field(..., title="food information")