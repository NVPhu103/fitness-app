from uuid import UUID
from fastapi import APIRouter, Depends, Request, Response
from typing import Any, Dict, List, Optional

from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.exercise_diary import (
    ExerciseDiaryModel,
    PostExerciseDiaryModel,
    ExerciseDiaryWithDiaryModel,
)
from fitness_api.schemas.diary import DiaryModel
from fitness_api import ctrl
from fitness_api.lib.paging import PaginationParams
from fitness_api.db.model import ExerciseDiary


PREFIX = "exercisediaries"
TAGS = ["exercisediaries"]
router = APIRouter()


@router.post(
    "",
    response_model=ExerciseDiaryWithDiaryModel,
    summary="Create a exercise diary",
    status_code=201,
)
async def create_exercise_diary(
    post_food_diary_model: PostExerciseDiaryModel,
    request: Request,
    response: Response,
    session: AsyncSession = Depends(create_session),
) -> ExerciseDiaryWithDiaryModel:
    (
        exercise_diary_record,
        diary_record,
    ) = await ctrl.exercise_diary.create_exercise_diary(post_food_diary_model, session)
    diary = DiaryModel.from_orm(diary_record).dict(by_alias=True)
    exercise_diary = ExerciseDiaryWithDiaryModel.from_orm(exercise_diary_record).dict(
        by_alias=True
    )
    exercise_diary.update({"diary": diary})
    return exercise_diary


@router.get(
    "/{diary_id}",
    response_model=Optional[Dict[Any, Any]],
    summary="Get list exercise diary by diary id",
    status_code=200,
)
async def get_exercise_diary_by_diary_id(
    request: Request,
    response: Response,
    diary_id: UUID,
    paging_params: PaginationParams = Depends(PaginationParams),
    session: AsyncSession = Depends(create_session),
) -> Optional[Dict[Any, Any]]:
    content = await ctrl.exercise_diary.list_all_exercise_diary_by_diary_id(
        session,
        diary_id,
        paging_params.page,
        paging_params.size,
    )
    burned_calories_of_exercise_diaries = 0
    exercise_diary_records: List[ExerciseDiary] = content.records
    list_exercise_diary = []
    for exercise_diary_record in exercise_diary_records:
        exercise_diary = ExerciseDiaryModel.from_orm(exercise_diary_record).dict(
            by_alias=True
        )
        list_exercise_diary.append(exercise_diary)
        burned_calories_of_exercise_diaries += exercise_diary["burnedCalories"]

    dict_result = {
        "listExerciseDiaries": list_exercise_diary,
        "burnedCaloriesOfExerciseDiaries": burned_calories_of_exercise_diaries,
    }

    return dict_result
