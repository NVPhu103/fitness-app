from uuid import UUID
from fastapi import APIRouter, Depends, Query, Request, Response, status
from typing import Any, Dict, List, Optional, Union

from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.food import FoodModel, PatchFoodModel, PostFoodModel
from fitness_api import ctrl
from fitness_api.lib.paging import PaginationParams
from fitness_api.db.model import Food, FoodStatus

PREFIX = "foods"
TAGS = ["foods"]
router = APIRouter()


@router.post("", response_model=FoodModel, summary="Create a food", status_code=201)
async def create_food(
    post_food_model: PostFoodModel,
    request: Request,
    response: Response,
    session: AsyncSession = Depends(create_session),
) -> FoodModel:
    food_record = await ctrl.food.create_food(post_food_model, session)
    food = FoodModel.from_orm(food_record).dict()
    return food


@router.get(
    "", response_model=List[FoodModel], summary="Get all foods", status_code=200
)
async def get_all_food(
    request: Request,
    response: Response,
    status: Optional[FoodStatus] = Query(default=FoodStatus.ACTIVE),
    paging_params: PaginationParams = Depends(PaginationParams),
    session: AsyncSession = Depends(create_session),
) -> List[Food]:
    content = await ctrl.food.list_all_foods(
        session, paging_params.page, paging_params.size, status
    )
    food_records: List[Food] = content.records
    return food_records


@router.get(
    "/{food_id}", response_model=FoodModel, summary="Get a food", status_code=200
)
async def get_food(
    request: Request,
    response: Response,
    food_id: UUID,
    session: AsyncSession = Depends(create_session),
) -> FoodModel:
    food_record = await ctrl.food.get_food(session, food_id)
    food = FoodModel.from_orm(food_record).dict()
    return food


@router.patch(
    "/{food_id}", summary="Update a food", status_code=204
)
async def update_food(
    request: Request,
    response: Response,
    food_id: UUID,
    patch_food_data: PatchFoodModel,
    session: AsyncSession = Depends(create_session),
) -> None:
    patch_food_data.status = FoodStatus.ACTIVE
    await ctrl.food.update_food(session, food_id, patch_food_data)
    response.status_code = 204
    return response


@router.patch(
    "/delete/{food_id}", summary="delete a food", status_code=204
)
async def delete_food(
    request: Request,
    response: Response,
    food_id: UUID,
    session: AsyncSession = Depends(create_session),
) -> None:
    patch_food_data = PatchFoodModel(status=FoodStatus.INACTIVE)
    await ctrl.food.update_food(session, food_id, patch_food_data)
    response.status_code = 204
    return response