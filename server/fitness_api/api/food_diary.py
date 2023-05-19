from datetime import date
from uuid import UUID
from fastapi import APIRouter, Depends, Query, Request, Response, status
from typing import Any, Dict, List, Optional, Union, Tuple

from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.food_diary import (
    FoodDiaryModel,
    FoodDiaryModelWithFoodModel,
    PatchFoodDiaryModel,
    PostFoodDiaryModel,
    FoodDiaryWithDiaryModel,
)
from fitness_api.schemas.diary import DiaryModel
from fitness_api.schemas.food import FoodModel
from fitness_api import ctrl
from fitness_api.lib.paging import PaginationParams
from fitness_api.lib.searcher.searcher import SearcherParams
from fitness_api.db.model import FoodDiary


PREFIX = "fooddiaries"
TAGS = ["fooddiaries"]
router = APIRouter()


@router.post(
    "",
    response_model=FoodDiaryWithDiaryModel,
    summary="Create a food diary",
    status_code=201,
)
async def create_food_diary(
    post_food_diary_model: PostFoodDiaryModel,
    request: Request,
    response: Response,
    session: AsyncSession = Depends(create_session),
) -> FoodDiaryWithDiaryModel:
    food_diary_record, diary_record = await ctrl.food_diary.create_food_diary(
        post_food_diary_model, session
    )
    diary = DiaryModel.from_orm(diary_record).dict(by_alias=True)
    food_diary = FoodDiaryWithDiaryModel.from_orm(food_diary_record).dict(by_alias=True)
    food_diary.update({"diary": diary})
    return food_diary


@router.get(
    "/{meal_id}",
    response_model=Optional[Dict[Any, Any]],
    summary="Get list food diary by meal id",
    status_code=200,
)
async def get_food_diary_by_meal_id(
    request: Request,
    response: Response,
    meal_id: UUID,
    paging_params: PaginationParams = Depends(PaginationParams),
    session: AsyncSession = Depends(create_session),
) -> Optional[Dict[Any, Any]]:
    content = await ctrl.food_diary.list_all_food_diary_by_meal_id(
        session,
        meal_id,
        paging_params.page,
        paging_params.size,
    )
    total_calories_of_food_diaries = 0
    food_diary_records: List[FoodDiary] = content.records

    food_diaries_with_food_model = []
    for food_diary_record in food_diary_records:
        food_diary_with_food = FoodDiaryModelWithFoodModel.from_orm(
            food_diary_record
        ).dict(by_alias=True)
        total_calories_of_food_diaries += food_diary_with_food["totalCalories"]
        food = await ctrl.food.get_food(session, food_diary_record.food_id)
        food_diary_with_food.update({"food": food})
        food_diaries_with_food_model.append(food_diary_with_food)

    dict_result = {
        "listFoodDiaries": food_diaries_with_food_model,
        "totalCaloriesOfFoodDiaries": total_calories_of_food_diaries,
    }

    return dict_result
