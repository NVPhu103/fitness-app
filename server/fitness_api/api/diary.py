from datetime import date
from uuid import UUID
from fastapi import APIRouter, Depends, Query, Request, Response, status
from typing import Any, Dict, List, Optional, Union

from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.diary import DiaryModel, PostDiaryModel, PatchDiaryModel
from fitness_api import ctrl
from fitness_api.lib.paging import PaginationParams
from fitness_api.lib.searcher.searcher import SearcherParams
from fitness_api.db.model import ExerciseDiary, FoodDiary


PREFIX = "diaries"
TAGS = ["diaries"]
router = APIRouter()


@router.get(
    "/{user_id}",
    response_model=DiaryModel,
    summary="Get diary by user id and date",
    status_code=200,
)
async def get_diary(
    request: Request,
    response: Response,
    user_id: UUID,
    date: date,
    session: AsyncSession = Depends(create_session),
) -> DiaryModel:
    diary_record = await ctrl.diary.get_diary(session, user_id, date)
    diary = DiaryModel.from_orm(diary_record).dict(by_alias=True)
    return diary


@router.get(
    "/calories/{user_id}",
    response_model=Optional[Dict[Any, Any]],
    summary="Get diary by user id and date",
    status_code=200,
)
async def get_all_calories(
    request: Request,
    response: Response,
    user_id: UUID,
    date: date,
    session: AsyncSession = Depends(create_session),
) -> Optional[Dict[Any, Any]]:
    diary_record = await ctrl.diary.get_diary(session, user_id, date)
    total_calories_of_food_diaries = 0
    burned_calories_of_exercise_diaries = 0

    # Get breakfast
    content = await ctrl.food_diary.list_all_food_diary_by_meal_id(
        session,
        diary_record.breakfast_id,
    )
    list_breakfast_food_record: List[FoodDiary] = content.records
    for breakfast_food_record in list_breakfast_food_record:
        total_calories_of_food_diaries += breakfast_food_record.total_calories
    
    # Get lunch
    content = await ctrl.food_diary.list_all_food_diary_by_meal_id(
        session,
        diary_record.lunch_id,
    )
    list_lunch_food_record: List[FoodDiary] = content.records
    for lunch_food_record in list_lunch_food_record:
        total_calories_of_food_diaries += lunch_food_record.total_calories
    
    # Get dining
    content = await ctrl.food_diary.list_all_food_diary_by_meal_id(
        session,
        diary_record.dining_id,
    )
    list_dining_food_record: List[FoodDiary] = content.records
    for dining_food_record in list_dining_food_record:
        total_calories_of_food_diaries += dining_food_record.total_calories
    
    # Get exercise
    content = await ctrl.exercise_diary.list_all_exercise_diary_by_diary_id(
        session,
        diary_record.id,
    )
    list_exercise_diary_record: List[ExerciseDiary] = content.records
    for exercise_diary_record in list_exercise_diary_record:
        burned_calories_of_exercise_diaries += exercise_diary_record.burned_calories

    dict_result = {
        "totalCaloriesOfFoodDiaries": total_calories_of_food_diaries,
        "burnedCaloriesOfExerciseDiaries": burned_calories_of_exercise_diaries,
    }

    return dict_result