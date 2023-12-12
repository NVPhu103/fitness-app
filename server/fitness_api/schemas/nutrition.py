from typing import Optional

from .config import BaseModelWithConfig
from pydantic import Field
from uuid import UUID


class BaseNutritionModel(BaseModelWithConfig):
    food_id: UUID = Field(..., title="Food id")
    calories: int = Field(..., title="The calories of the food")


class PostNutritionModel(BaseNutritionModel):
    class Config(BaseNutritionModel.Config):
        schema_extra = {
            "example": {
                "food_id": "aae992db-bb4c-43da-8118-5f9696a8a221",
                "calories": 332,
            }
        }


class PatchNutritionModel(BaseModelWithConfig):
    protein: Optional[float] = Field(None, description="Measure in gram")
    total_fat: Optional[float] = Field(
        None, description="Measure in gram", alias="totalFat"
    )
    cholesterol: Optional[int] = Field(None, description="Measure in milligram")
    carbohydrate: Optional[float] = Field(None, description="Measure in gram")
    sugars: Optional[float] = Field(None, description="Measure in gram")
    dietary_fiber: Optional[float] = Field(
        None, description="Measure in gram", alias="dietaryFiber"
    )
    vitamin_a: Optional[int] = Field(
        None, description="Measure in milligram", alias="vitaminA"
    )
    vitamin_b_1: Optional[int] = Field(
        None, description="Measure in milligram", alias="vitaminB1"
    )
    vitamin_b_2: Optional[int] = Field(
        None, description="Measure in milligram", alias="vitaminB2"
    )
    vitamin_b_6: Optional[int] = Field(
        None, description="Measure in milligram", alias="vitaminB6"
    )
    vitamin_b_9: Optional[int] = Field(
        None, description="Measure in milligram", alias="vitaminB9"
    )
    vitamin_b_12: Optional[int] = Field(
        None, description="Measure in milligram", alias="vitaminB12"
    )
    vitamin_c: Optional[int] = Field(
        None, description="Measure in milligram", alias="vitaminC"
    )
    vitamin_d: Optional[int] = Field(
        None, description="Measure in milligram", alias="vitaminD"
    )
    vitamin_e: Optional[int] = Field(
        None, description="Measure in milligram", alias="vitaminE"
    )
    vitamin_k: Optional[int] = Field(
        None, description="Measure in milligram", alias="vitaminK"
    )
    canxi: Optional[int] = Field(None, description="Measure in milligram")
    phospho: Optional[int] = Field(None, description="Measure in milligram")
    fe: Optional[int] = Field(None, description="Measure in milligram")
    magie: Optional[int] = Field(None, description="Measure in milligram")
    zn: Optional[int] = Field(None, description="Measure in milligram")
    natri: Optional[int] = Field(None, description="Measure in milligram")
    iod: Optional[int] = Field(None, description="Measure in milligram")
    omega_3: Optional[int] = Field(
        None, description="Measure in milligram", alias="omega3"
    )
    omega_6: Optional[int] = Field(
        None, description="Measure in milligram", alias="omega6"
    )
    omega_9: Optional[int] = Field(
        None, description="Measure in milligram", alias="omega9"
    )

    class Config(BaseModelWithConfig.Config):
        schema_extra = {
            "example": {
                "protein": 125.5,
                "totalFat": 20,
                "cholesterol": 21,
                "carbohydrate": 22,
                "sugars": 23,
                "dietaryFiber": 0,
                "vitaminA": 0,
                "vitaminB1": 0,
                "vitaminB2": 0,
                "vitaminB6": 0,
                "vitaminB9": 0,
                "vitaminB12": 0,
                "vitaminC": 0,
                "vitaminD": 0,
                "vitaminE": 0,
                "vitaminK": 0,
                "canxi": 0,
                "phospho": 0,
                "fe": 0,
                "magie": 0,
                "zn": 0,
                "natri": 0,
                "iod": 0,
                "omega3": 0,
                "omega6": 0,
                "omega9": 0
            }
        }


class NutritionModel(BaseNutritionModel):
    protein: float = Field(..., description="Measure in gram")
    total_fat: float = Field(
        None, description="Measure in gram", alias="totalFat"
    )
    cholesterol: int = Field(..., description="Measure in milligram")
    carbohydrate: float = Field(..., description="Measure in gram")
    sugars: float = Field(..., description="Measure in gram")
    dietary_fiber: float = Field(
        ..., description="Measure in gram", alias="dietaryFiber"
    )
    vitamin_a: int = Field(
        ..., description="Measure in milligram", alias="vitaminA"
    )
    vitamin_b_1: int = Field(
        ..., description="Measure in milligram", alias="vitaminB1"
    )
    vitamin_b_2: int = Field(
        ..., description="Measure in milligram", alias="vitaminB2"
    )
    vitamin_b_6: int = Field(
        ..., description="Measure in milligram", alias="vitaminB6"
    )
    vitamin_b_9: int = Field(
        ..., description="Measure in milligram", alias="vitaminB9"
    )
    vitamin_b_12: int = Field(
        ..., description="Measure in milligram", alias="vitaminB12"
    )
    vitamin_c: int = Field(
        ..., description="Measure in milligram", alias="vitaminC"
    )
    vitamin_d: int = Field(
        ..., description="Measure in milligram", alias="vitaminD"
    )
    vitamin_e: int = Field(
        ..., description="Measure in milligram", alias="vitaminE"
    )
    vitamin_k: int = Field(
        ..., description="Measure in milligram", alias="vitaminK"
    )
    canxi: int = Field(..., description="Measure in milligram")
    phospho: int = Field(..., description="Measure in milligram")
    fe: int = Field(..., description="Measure in milligram")
    magie: int = Field(..., description="Measure in milligram")
    zn: int = Field(..., description="Measure in milligram")
    natri: int = Field(..., description="Measure in milligram")
    iod: int = Field(..., description="Measure in milligram")
    omega_3: int = Field(
        ..., description="Measure in milligram", alias="omega3"
    )
    omega_6: int = Field(
        ..., description="Measure in milligram", alias="omega6"
    )
    omega_9: int = Field(
        ..., description="Measure in milligram", alias="omega9"
    )

    class Config(BaseModelWithConfig.Config):
        schema_extra = {
            "example": {
                "food_id": "aae992db-bb4c-43da-8118-5f9696a8a221",
                "calories": 332,
                "protein": 125.5,
                "totalFat": 20,
                "cholesterol": 21,
                "carbohydrate": 22,
                "sugars": 23,
                "dietaryFiber": 0,
                "vitaminA": 0,
                "vitaminB1": 0,
                "vitaminB2": 0,
                "vitaminB6": 0,
                "vitaminB9": 0,
                "vitaminB12": 0,
                "vitaminC": 0,
                "vitaminD": 0,
                "vitaminE": 0,
                "vitaminK": 0,
                "canxi": 0,
                "phospho": 0,
                "fe": 0,
                "magie": 0,
                "zn": 0,
                "natri": 0,
                "iod": 0,
                "omega3": 0,
                "omega6": 0,
                "omega9": 0
            }
        }
