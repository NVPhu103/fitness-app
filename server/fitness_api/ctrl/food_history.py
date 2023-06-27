from typing import List, Optional
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from sqlalchemy import select, desc, and_


from fastapi import HTTPException
from fitness_api.schemas.food_history import (
    PostFoodHistoryModel,
    PatchFoodHistoryModel,
    FoodHistoryModel,
)
from fitness_api.db.model import FoodHistory


async def list_all_food_histories(
    session: AsyncSession,
    user_id: int,
) -> List[FoodHistory]:
    statement = (
        select(FoodHistory)
        .filter(FoodHistory.user_id == user_id)
        .order_by(desc(FoodHistory.number_of_uses))
    )
    result = await session.execute(statement)
    food_records: List[FoodHistory] = result.scalars().fetchmany(10)
    return food_records


async def create_or_update_food_history(
    session: AsyncSession,
    user_id: UUID,
    food_id: UUID,
) -> None:
    statement = select(FoodHistory).filter(
        and_(FoodHistory.user_id == user_id, FoodHistory.food_id == food_id)
    )
    food_history = (await session.execute(statement=statement)).scalar_one_or_none()
    try:
        if food_history:
            food_history.number_of_uses += 1
            await session.flush()
        else:
            new_food_history = FoodHistory(**{"user_id": user_id, "food_id": food_id})
            session.add(new_food_history)
        await session.commit()
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(detail=f"{error}", status_code=400) from error
