from typing import Optional
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from fitness_api.schemas.nutrition import PostNutritionModel, PatchNutritionModel
from fitness_api.db.model import Nutrition


async def create_nutrition(
    post_nutrition_model: PostNutritionModel, session: AsyncSession
) -> Nutrition:
    try:
        model = Nutrition(**post_nutrition_model.dict(exclude_unset=True))
        session.add(model)
        await session.commit()
        return model
    except IntegrityError as err:
        await session.rollback()
        raise HTTPException(detail=f"{err}", status_code=400)


async def get_nutrition(
    session: AsyncSession,
    food_id: UUID,
) -> Nutrition:
    nutrition_record: Optional[Nutrition] = await session.get(
        Nutrition, food_id, populate_existing=True
    )
    if nutrition_record:
        return nutrition_record
    else:
        raise HTTPException(status_code=404, detail="Nutrition info does not exist")


async def update_nutrition(
    session: AsyncSession,
    food_id: UUID,
    patch_nutrition_data: PatchNutritionModel,
) -> Nutrition:
    if not (data := patch_nutrition_data.dict(exclude_unset=True)):
        raise HTTPException(status_code=400, detail="No changes submitted")
    nutrition_record = await get_nutrition(session, food_id)
    try:
        nutrition_record.apply_update(**data)
        await session.commit()
    except IntegrityError as err:
        await session.rollback()
        raise HTTPException(status_code=400, detail=f"{err}")
