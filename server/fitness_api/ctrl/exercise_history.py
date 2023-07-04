from typing import List, Optional
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from sqlalchemy import select, desc, and_, or_


from fastapi import HTTPException
from fitness_api.schemas.exercise_history import (
    PostExerciseHistoryModel,
    PatchExerciseHistoryModel,
    ExerciseHistoryModel,
)
from fitness_api.db.model import ExerciseHistory, Exercise
from fitness_api.schemas.exercise import ExerciseType


async def list_all_exercise_histories(
    session: AsyncSession,
    user_id: int,
    exercise_type: ExerciseType,
) -> List[ExerciseHistory]:
    statement = (
        select(ExerciseHistory)
        .join(Exercise)
        .filter(
            and_(
                ExerciseHistory.user_id == user_id,
                Exercise.exercise_type == exercise_type,
            )
        )
        .order_by(desc(ExerciseHistory.number_of_uses))
    )
    result = await session.execute(statement)
    exercise_history_records: List[ExerciseHistory] = result.scalars().fetchmany(10)
    return exercise_history_records


async def create_or_update_exercise_history(
    session: AsyncSession,
    user_id: UUID,
    exercise_id: UUID,
) -> None:
    statement = select(ExerciseHistory).filter(
        and_(
            ExerciseHistory.user_id == user_id,
            ExerciseHistory.exercise_id == exercise_id,
        )
    )
    exercise_history = (await session.execute(statement=statement)).scalar_one_or_none()
    try:
        if exercise_history:
            exercise_history.number_of_uses += 1
            await session.flush()
        else:
            new_exercise_history = ExerciseHistory(
                **{"user_id": user_id, "exercise_id": exercise_id}
            )
            session.add(new_exercise_history)
        await session.commit()
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(detail=f"{error}", status_code=400) from error
