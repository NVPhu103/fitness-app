from datetime import date
from uuid import UUID
from fastapi import APIRouter, Depends, Query, Request, Response, status
from typing import Any, Dict, List, Optional, Union

from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.food_diary import (
    FoodDiaryModel,
    PatchFoodDiaryModel,
    PostFoodDiaryModel,
)
from fitness_api import ctrl
from fitness_api.lib.paging import PaginationParams
from fitness_api.lib.searcher.searcher import SearcherParams


PREFIX = "fooddiaries"
TAGS = ["fooddiaries"]
router = APIRouter()


@router.post(
    "", response_model=FoodDiaryModel, summary="Create a food diary", status_code=201
)
async def create_food_diary(
    post_food_diary_model: PostFoodDiaryModel,
    request: Request,
    response: Response,
    session: AsyncSession = Depends(create_session),
) -> FoodDiaryModel:
    food_diary_record = await ctrl.food_diary.create_food_diary(
        post_food_diary_model, session
    )
    food_diary = FoodDiaryModel.from_orm(food_diary_record).dict(by_alias=True)
    return food_diary
