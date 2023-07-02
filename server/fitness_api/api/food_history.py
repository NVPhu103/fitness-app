from datetime import date
from uuid import UUID
from fastapi import APIRouter, Depends, Query, Request, Response, status
from typing import Any, Dict, List, Optional, Union, Tuple

from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.food_history import (
    PostFoodHistoryModel,
    PatchFoodHistoryModel,
    FoodHistoryModel,
)

# from fitness_api.schemas.diary import DiaryModel
# from fitness_api.schemas.food import FoodModel
from fitness_api import ctrl
from fitness_api.lib.paging import PaginationParams
from fitness_api.lib.searcher.searcher import SearcherParams
from fitness_api.db.model import FoodHistory


PREFIX = "foodhistories"
TAGS = ["foodhistories"]
router = APIRouter()


@router.get(
    "/{user_id}",
    response_model=List[FoodHistoryModel],
    summary="Get all food histories",
    status_code=200,
)
async def get_all_food_histories(
    request: Request,
    response: Response,
    user_id: UUID,
    session: AsyncSession = Depends(create_session),
) -> List[FoodHistory]:
    list_food_histories = await ctrl.food_history.list_all_food_histories(
        session, user_id
    )
    return list_food_histories
