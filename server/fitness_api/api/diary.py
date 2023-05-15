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


PREFIX = "diary"
TAGS = ["diary"]
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
