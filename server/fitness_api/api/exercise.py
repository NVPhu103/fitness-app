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
