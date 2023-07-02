from typing import List, Optional
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from sqlalchemy import and_, or_, select


from fastapi import HTTPException
from fitness_api.schemas.exercise_diary import (
    ExerciseDiaryModel,
    PostExerciseDiaryModel,
    ExerciseDiaryWithDiaryModel,
)
from fitness_api.schemas.exercise import ExerciseStatus, BurningType
from fitness_api.db.model import ExerciseDiary, Exercise, Diary
from fitness_api.lib.paging import DEFAULT_PAGE_NUMBER, DEFAULT_PAGE_SIZE
from fitness_api.lib.paging.types import PagedResultSet
from fitness_api.lib.paging.utils import count_query, paginate_query
from fitness_api.lib.searcher.searcher import SearcherParams, Searcher

from fitness_api.ctrl.exercise_history import create_or_update_exercise_history


async def create_exercise_diary(
    post_exercise_diary_model: PostExerciseDiaryModel, session: AsyncSession
) -> ExerciseDiary:
    exercise = await session.get(Exercise, post_exercise_diary_model.exercise_id)
    if not exercise or exercise.status == ExerciseStatus.INACTIVE:
        raise HTTPException(detail="Exercise does not exist", status_code=404)
    burned_calories = exercise.burned_calories * (
        post_exercise_diary_model.practice_time / 60
        if exercise.burning_type == BurningType.CPH.value
        else post_exercise_diary_model.practice_time
    )
    # get diary to check
    statement = select(Diary).filter(Diary.id == post_exercise_diary_model.diary_id)
    result = await session.execute(statement=statement)
    if not (diary := result.scalar_one_or_none()):
        raise HTTPException(detail="Diary does not exist", status_code=404)
    try:
        exercise_diary_record = await get_exercise_diary_by_diary_id_and_exercise_id(
            session,
            post_exercise_diary_model.diary_id,
            post_exercise_diary_model.exercise_id,
        )
        if exercise_diary_record:
            new_practice_time = (
                exercise_diary_record.practice_time
                + post_exercise_diary_model.practice_time
            )
            new_burned_calories = (
                exercise_diary_record.burned_calories + burned_calories
            )
            update_data = {
                "practice_time": new_practice_time,
                "burned_calories": new_burned_calories,
            }
            exercise_diary_record.apply_update(**update_data)
            await session.flush()
            # update diary
            diary.total_calorie_intake -= burned_calories
            await create_or_update_exercise_history(session, diary.user_id, exercise.id)
            await session.commit()
            return exercise_diary_record, diary
        else:
            model = ExerciseDiary(**post_exercise_diary_model.dict(exclude_unset=True))
            model.burned_calories = burned_calories
            session.add(model)
            # update diary
            diary.total_calorie_intake -= burned_calories
            await create_or_update_exercise_history(session, diary.user_id, exercise.id)
            await session.commit()
            return model, diary
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(detail=f"{error}", status_code=400) from error


async def get_exercise_diary_by_diary_id_and_exercise_id(
    session: AsyncSession,
    diary_id: UUID,
    exercise_id: UUID,
) -> Optional[ExerciseDiary]:
    statement = select(ExerciseDiary).filter(
        and_(
            ExerciseDiary.diary_id == diary_id, ExerciseDiary.exercise_id == exercise_id
        )
    )
    result = await session.execute(statement=statement)
    exercise_diary_record = result.scalar_one_or_none()
    return exercise_diary_record


async def list_all_exercise_diary_by_diary_id(
    session: AsyncSession,
    diary_id: UUID,
    page: int = DEFAULT_PAGE_NUMBER,
    size: int = DEFAULT_PAGE_SIZE,
) -> PagedResultSet[ExerciseDiary]:
    statement = select(ExerciseDiary).filter(ExerciseDiary.diary_id == diary_id)

    paged_statement = paginate_query(statement, page, size)

    result = await session.execute(paged_statement)
    exercise_diary_records: List[ExerciseDiary] = result.scalars().all()
    total_query = count_query(paged_statement, ExerciseDiary)
    total = (await session.execute(total_query)).scalar_one()

    return PagedResultSet(
        page=page, size=size, total=total, records=exercise_diary_records
    )
