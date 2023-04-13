from typing import List, Optional
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError, NoResultFound
from sqlalchemy import select, func


from fastapi import HTTPException, Response
from fastapi.exception_handlers import http_exception_handler
from fitness_api.schemas.user_profile import UserProfileModel, PostUserProfileModel
from fitness_api.db.model import UserProfile

from fitness_api.lib.paging import DEFAULT_PAGE_NUMBER, DEFAULT_PAGE_SIZE
from fitness_api.lib.paging.types import PagedResultSet
from fitness_api.lib.paging.utils import count_query, paginate_query
from fitness_api.lib.searcher.searcher import SearcherParams, Searcher


async def get_user_profile(
    session: AsyncSession,
    user_id: UUID,
) -> Optional[UserProfile]:
    statement = select(UserProfile).filter(UserProfile.user_id == user_id)
    user_profile_record: Optional[UserProfile] = (await session.execute(statement)).first()
    return user_profile_record


async def create_user_profile(post_user_profile_model: PostUserProfileModel, session: AsyncSession) -> UserProfile:
    try:
        model = UserProfile(**post_user_profile_model.dict(exclude_unset=True))
        session.add(model)
        await session.commit()
        return model
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(detail=f"{error}", status_code=400) from error

