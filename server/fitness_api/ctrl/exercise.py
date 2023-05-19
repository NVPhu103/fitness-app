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


async def create_exercise(
    post_exercise_model: PostExerciseModel, session: AsyncSession
) -> Exercise:
    try:
        model = Exercise(**post_exercise_model.dict(exclude_unset=True))
        session.add(model)
        await session.commit()
        return model
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(
            detail="Exercise already exists", status_code=409
        ) from error


async def list_all_exercises(
    session: AsyncSession,
    searcher_params: SearcherParams,
    page: int = DEFAULT_PAGE_NUMBER,
    size: int = DEFAULT_PAGE_SIZE,
) -> PagedResultSet[Exercise]:
    statement = select(Exercise)
    searcher = Searcher(searcher_params, Exercise, ExerciseModel, "name")
    statement = await searcher.apply_searcher(statement)
    paged_statement = paginate_query(statement, page, size)

    result = await session.execute(paged_statement)
    exercise_records: List[Exercise] = result.scalars().all()
    total_query = count_query(paged_statement, Exercise)
    total = (await session.execute(total_query)).scalar_one()

    return PagedResultSet(page=page, size=size, total=total, records=exercise_records)


async def get_exercise(
    session: AsyncSession,
    exercise_id: UUID,
) -> Optional[Exercise]:
    exercise_record: Optional[Exercise] = await session.get(
        Exercise, exercise_id, populate_existing=True
    )
    if exercise_record:
        return exercise_record
    else:
        raise HTTPException(status_code=404, detail="Exercise does not exist")


async def update_exercise(
    session: AsyncSession,
    exercise_id: UUID,
    patch_exercise_data: PatchExerciseModel,
) -> Exercise:
    if not (data := patch_exercise_data.dict(exclude_unset=True)):
        raise ValueError("No changes submitted.")
    exercise_record = await get_exercise(session, exercise_id)
    try:
        exercise_record.apply_update(**data)
        await session.commit()
    except IntegrityError as exc:
        await session.rollback()
        raise HTTPException(status_code=400, detail="Error")
