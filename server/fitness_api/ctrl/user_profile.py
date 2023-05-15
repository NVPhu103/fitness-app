from datetime import datetime
from typing import List, Optional
from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError, NoResultFound
from sqlalchemy import select, func


from fastapi import HTTPException, Response
from fastapi.exception_handlers import http_exception_handler
from fitness_api.schemas.user_profile import (
    UserProfileActivityLevel,
    UserProfileGender,
    UserProfileModel,
    PostUserProfileModel,
)
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
    user_profile_record: Optional[UserProfile] = (
        await session.execute(statement)
    ).scalar_one_or_none()
    return user_profile_record


async def create_user_profile(
    post_user_profile_model: PostUserProfileModel, session: AsyncSession
) -> UserProfile:
    try:
        maximum_calorie_intake = (
            (6.25 * post_user_profile_model.height)
            + (10 * post_user_profile_model.current_weight)
            - (5 * (datetime.today().year - post_user_profile_model.year_of_birth))
        )
        if post_user_profile_model.gender == UserProfileGender.FEMALE:
            maximum_calorie_intake = maximum_calorie_intake - 161
        if post_user_profile_model.gender == UserProfileGender.MALE:
            maximum_calorie_intake = maximum_calorie_intake + 5
        if (
            post_user_profile_model.activity_level
            == UserProfileActivityLevel.NOT_VERY_ACTIVE
        ):
            maximum_calorie_intake = maximum_calorie_intake * 1.2
        if (
            post_user_profile_model.activity_level
            == UserProfileActivityLevel.LIGHTLY_ACTIVE
        ):
            maximum_calorie_intake = maximum_calorie_intake * 1.375
        if post_user_profile_model.activity_level == UserProfileActivityLevel.ACTIVE:
            maximum_calorie_intake = maximum_calorie_intake * 1.725
        if (
            post_user_profile_model.activity_level
            == UserProfileActivityLevel.VERY_ACTIVE
        ):
            maximum_calorie_intake = maximum_calorie_intake * 1.9
        post_user_profile_model.maximum_calorie_intake = maximum_calorie_intake
        model = UserProfile(**post_user_profile_model.dict(exclude_unset=True))
        session.add(model)
        await session.commit()
        return model
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(detail=f"{error}", status_code=400) from error
