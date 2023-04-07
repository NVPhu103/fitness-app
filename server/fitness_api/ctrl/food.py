from typing import List, Optional
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError, NoResultFound
from sqlalchemy import select, func


from fastapi import HTTPException, Response
from fastapi.exception_handlers import http_exception_handler
from fitness_api.schemas.food import (
    FoodModel,
    FoodStatus,
    PatchFoodModel,
    PostFoodModel,
)
from fitness_api.db.model import Food
from fitness_api.lib.paging import DEFAULT_PAGE_NUMBER, DEFAULT_PAGE_SIZE
from fitness_api.lib.paging.types import PagedResultSet
from fitness_api.lib.paging.utils import count_query, paginate_query


async def create_food(post_food_model: PostFoodModel, session: AsyncSession) -> Food:
    try:
        model = Food(**post_food_model.dict(exclude_unset=True))
        session.add(model)
        await session.commit()
        return model
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(detail="Food already exists", status_code=409) from error


async def list_all_foods(
    session: AsyncSession,
    page: int = DEFAULT_PAGE_NUMBER,
    size: int = DEFAULT_PAGE_SIZE,
    status: FoodStatus = FoodStatus.ACTIVE,
) -> PagedResultSet[Food]:
    statement = select(Food).filter(Food.status == status.value)
    paged_statement = paginate_query(statement, page, size)

    result = await session.execute(paged_statement)
    food_records: List[Food] = result.scalars().all()
    total_query = count_query(paged_statement, Food)
    total = (await session.execute(total_query)).scalar_one()

    return PagedResultSet(page=page, size=size, total=total, records=food_records)


async def update_food(
    session: AsyncSession,
    food_id: UUID,
    patch_food_data: PatchFoodModel,
) -> Food:
    if not (data := patch_food_data.dict(exclude_unset=True)):
        raise ValueError("No changes submitted.")
    food_record = await get_food(session, food_id)
    try:
        food_record.apply_update(**data)
        await session.commit()
    except IntegrityError as exc:
        await session.rollback()
        raise HTTPException(status_code=400, detail="Error")


async def get_food(
    session: AsyncSession,
    food_id: UUID,
) -> Optional[Food]:
    food_record: Optional[Food] = await session.get(Food, food_id, populate_existing=True)
    if food_record:
        return food_record
    else:
        raise HTTPException(status_code=404, detail="food does not exist")
