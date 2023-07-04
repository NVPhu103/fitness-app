from datetime import date
from uuid import UUID
from fastapi import APIRouter, Depends, Query, Request, Response, status
from typing import Any, Dict, List, Optional, Union, Tuple

from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.exercise_history import (
    PostExerciseHistoryModel,
    PatchExerciseHistoryModel,
    ExerciseHistoryModel,
)
from fitness_api.schemas.exercise import ExerciseType
from fitness_api import ctrl
from fitness_api.db.model import ExerciseHistory


PREFIX = "exercisehistories"
TAGS = ["exercisehistories"]
router = APIRouter()


@router.get(
    "/{user_id}/{exercise_type}",
    response_model=List[ExerciseHistoryModel],
    summary="Get all exercise histories",
    status_code=200,
)
async def get_all_exercise_histories(
    request: Request,
    response: Response,
    user_id: UUID,
    exercise_type: ExerciseType,
    session: AsyncSession = Depends(create_session),
) -> List[ExerciseHistory]:
    list_exercise_histories = await ctrl.exercise_history.list_all_exercise_histories(
        session, user_id, exercise_type
    )
    return list_exercise_histories
