from datetime import date
from typing import List, Optional
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from sqlalchemy import and_, select


from fastapi import HTTPException
from fitness_api.schemas.diary import (
    DiaryModel,
    PatchDiaryModel,
    PostDiaryModel,
)
from fitness_api.db.model import Diary
from fitness_api.lib.paging import DEFAULT_PAGE_NUMBER, DEFAULT_PAGE_SIZE
from fitness_api.lib.paging.types import PagedResultSet
from fitness_api.lib.paging.utils import count_query, paginate_query
from fitness_api.lib.searcher.searcher import SearcherParams, Searcher

from fitness_api import ctrl


async def get_diary(
    session: AsyncSession,
    user_id: UUID,
    date: date,
) -> Optional[Diary]:
    statement = select(Diary).filter(and_(Diary.user_id == user_id, Diary.date == date))

    result = await session.execute(statement=statement)
    if diary := result.scalar_one_or_none():
        return diary

    try:
        user = await ctrl.user_profile.get_user_profile(session, user_id)
        post_diary_model = {
            "user_id": user.user_id,
            "date": date,
            "maximum_calorie_intake": user.maximum_calorie_intake,
        }
        model = Diary(**post_diary_model)
        session.add(model)
        await session.commit()
        return model
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(detail="Diary error", status_code=404) from error
