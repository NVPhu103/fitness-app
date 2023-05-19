from typing import Optional
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from sqlalchemy import and_, or_, select


from fastapi import HTTPException
from fitness_api.schemas.food_diary import (
    FoodDiaryModel,
    PatchFoodDiaryModel,
    PostFoodDiaryModel,
)
from fitness_api.schemas.food import FoodStatus
from fitness_api.db.model import FoodDiary, Food, Diary
from fitness_api.lib.paging import DEFAULT_PAGE_NUMBER, DEFAULT_PAGE_SIZE
from fitness_api.lib.paging.types import PagedResultSet
from fitness_api.lib.paging.utils import count_query, paginate_query
from fitness_api.lib.searcher.searcher import SearcherParams, Searcher


async def create_food_diary(
    post_food_diary_model: PostFoodDiaryModel, session: AsyncSession
) -> FoodDiary:
    food = await session.get(Food, post_food_diary_model.food_id)
    if not food or food.status == FoodStatus.INACTIVE:
        raise HTTPException(detail="Food does not exist", status_code=404)
    total_calories = food.calories * post_food_diary_model.quantity
    # get diary to check
    statement = select(Diary).filter(
        or_(
            Diary.breakfast_id == post_food_diary_model.meal_id,
            Diary.dining_id == post_food_diary_model.meal_id,
            Diary.lunch_id == post_food_diary_model.meal_id,
        )
    )
    result = await session.execute(statement=statement)
    if not (diary := result.scalar_one_or_none()):
        raise HTTPException(detail="Diary does not exist", status_code=404)
    try:
        food_diary_record = await get_food_diary_by_meal_id_and_food_id(
            session, post_food_diary_model.meal_id, post_food_diary_model.food_id
        )
        if food_diary_record:
            new_quantity = food_diary_record.quantity + post_food_diary_model.quantity
            new_total_calories = food_diary_record.total_calories + total_calories
            update_data = {
                "quantity": new_quantity,
                "total_calories": new_total_calories,
            }
            food_diary_record.apply_update(**update_data)
            await session.flush()
            # update diary
            diary.total_calorie_intake += total_calories
            await session.commit()
            return food_diary_record
        else:
            model = FoodDiary(**post_food_diary_model.dict(exclude_unset=True))
            model.total_calories = total_calories
            session.add(model)
            # update diary
            diary.total_calorie_intake += total_calories
            await session.commit()
            return model
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(detail="Something wrong", status_code=409) from error


async def get_food_diary_by_meal_id_and_food_id(
    session: AsyncSession,
    meal_id: UUID,
    food_id: UUID,
) -> Optional[FoodDiary]:
    statement = select(FoodDiary).filter(
        and_(FoodDiary.meal_id == meal_id, FoodDiary.food_id == food_id)
    )
    result = await session.execute(statement=statement)
    food_diary_record = result.scalar_one_or_none()
    return food_diary_record
