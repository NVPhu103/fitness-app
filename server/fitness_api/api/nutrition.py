from uuid import UUID
from fastapi import APIRouter, Depends, Query, Request, Response, status
from typing import Any, Dict, List, Optional, Union

from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.nutrition import NutritionModel, PatchNutritionModel
from fitness_api import ctrl
from fitness_api.db.model import Nutrition


PREFIX = "nutritions"
TAGS = ["nutritions"]
router = APIRouter()


@router.patch(
    "/{food_id}",
    summary="Update nutrition info of a food",
    status_code=204,
    description="Update nutrition info of a food",
)
async def update_nutrition(
    request: Request,
    response: Response,
    food_id: UUID,
    patch_nutrition_data: PatchNutritionModel,
    session: AsyncSession = Depends(create_session),
) -> None:
    await ctrl.nutrition.update_nutrition(session, food_id, patch_nutrition_data)
    response.status_code = 204
    return response


@router.get(
    "/{food_id}",
    response_model=NutritionModel,
    summary="Get nutrition info of a food",
    status_code=200,
)
async def get_nutrition(
    request: Request,
    response: Response,
    food_id: UUID,
    session: AsyncSession = Depends(create_session),
) -> NutritionModel:
    nutrition_record = await ctrl.nutrition.get_nutrition(session, food_id)
    nutrition = NutritionModel.from_orm(nutrition_record).dict(by_alias=True)
    return nutrition
