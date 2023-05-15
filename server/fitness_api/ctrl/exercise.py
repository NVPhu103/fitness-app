from typing import List, Optional
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from sqlalchemy import select


from fastapi import HTTPException
from fitness_api.schemas.exercise import (
    ExerciseModel,
    PostExerciseModel,
    PatchExerciseModel,
)
from fitness_api.db.model import Exercise
from fitness_api.lib.paging import DEFAULT_PAGE_NUMBER, DEFAULT_PAGE_SIZE
from fitness_api.lib.paging.types import PagedResultSet
from fitness_api.lib.paging.utils import count_query, paginate_query
from fitness_api.lib.searcher.searcher import SearcherParams, Searcher


async def create_exercise(post_exercise_model: PostExerciseModel, session: AsyncSession) -> Exercise:
    try:
        model = Exercise(**post_exercise_model.dict(exclude_unset=True))
        session.add(model)
        await session.commit()
        return model
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(detail="Exercise already exists", status_code=409) from error