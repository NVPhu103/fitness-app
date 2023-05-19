from uuid import UUID
from fastapi import APIRouter, Depends, Query, Request, Response, status
from typing import Any, Dict, List, Optional, Union

from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.exercise import (
    PostExerciseModel,
    PatchExerciseModel,
    ExerciseModel,
)
from fitness_api.db.model import Exercise
from fitness_api import ctrl
from fitness_api.lib.paging import PaginationParams
from fitness_api.lib.searcher.searcher import SearcherParams


PREFIX = "exercises"
TAGS = ["exercises"]
router = APIRouter()


@router.post(
    "", response_model=ExerciseModel, summary="Create a exercise", status_code=201
)
async def create_exercise(
    post_exercise_model: PostExerciseModel,
    request: Request,
    response: Response,
    session: AsyncSession = Depends(create_session),
) -> ExerciseModel:
    exercise_record = await ctrl.exercise.create_exercise(post_exercise_model, session)
    exercise = ExerciseModel.from_orm(exercise_record).dict(by_alias=True)
    return exercise


@router.get(
    "", response_model=List[ExerciseModel], summary="Get all exercise", status_code=200
)
async def get_all_exercises(
    request: Request,
    response: Response,
    searcher_params: SearcherParams = Depends(SearcherParams),
    paging_params: PaginationParams = Depends(PaginationParams),
    session: AsyncSession = Depends(create_session),
) -> List[Exercise]:
    content = await ctrl.exercise.list_all_exercises(
        session, searcher_params, paging_params.page, paging_params.size
    )
    exercise_records: List[Exercise] = content.records
    return exercise_records


@router.get(
    "/{exercise_id}",
    response_model=ExerciseModel,
    summary="Get a exercise",
    status_code=200,
)
async def get_exercise(
    request: Request,
    response: Response,
    exercise_id: UUID,
    session: AsyncSession = Depends(create_session),
) -> ExerciseModel:
    exercise_record = await ctrl.exercise.get_exercise(session, exercise_id)
    exercise = ExerciseModel.from_orm(exercise_record).dict(by_alias=True)
    return exercise


@router.patch(
    "/{exercise_id}",
    summary="Update a exercise",
    status_code=204,
    description="update the exercise by its ID",
)
async def update_food(
    request: Request,
    response: Response,
    exercise_id: UUID,
    patch_exercise_data: PatchExerciseModel,
    session: AsyncSession = Depends(create_session),
) -> None:
    await ctrl.exercise.update_exercise(session, exercise_id, patch_exercise_data)
    response.status_code = 204
    return response
