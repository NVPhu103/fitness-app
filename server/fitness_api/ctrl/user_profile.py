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
    UserProfileGoal,
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
        BRM = (
            (6.25 * post_user_profile_model.height)
            + (10 * post_user_profile_model.current_weight)
            - (4.92 * (datetime.today().year - post_user_profile_model.year_of_birth))
        )
        if post_user_profile_model.gender == UserProfileGender.FEMALE:
            BRM = BRM - 161
        if post_user_profile_model.gender == UserProfileGender.MALE:
            BRM = BRM + 5
        if (
            post_user_profile_model.activity_level
            == UserProfileActivityLevel.NOT_VERY_ACTIVE
        ):
            TDEE = BRM * 1.2
        if (
            post_user_profile_model.activity_level
            == UserProfileActivityLevel.LIGHTLY_ACTIVE
        ):
            TDEE = BRM * 1.375
        if post_user_profile_model.activity_level == UserProfileActivityLevel.ACTIVE:
            TDEE = BRM * 1.55
        if (
            post_user_profile_model.activity_level
            == UserProfileActivityLevel.VERY_ACTIVE
        ):
            TDEE = BRM * 1.9

        if post_user_profile_model.goal == UserProfileGoal.MAINTAIN_WEIGHT:
            MCI = TDEE
        if post_user_profile_model.goal == UserProfileGoal.GAIN_WEIGHT:
            if (
                post_user_profile_model.current_weight
                >= post_user_profile_model.desired_weight
            ):
                raise HTTPException(
                    detail="current weight must be less than desired weight",
                    status_code=400,
                )
            MCI = TDEE + 550
        if post_user_profile_model.goal == UserProfileGoal.LOSE_WEIGHT:
            if (
                post_user_profile_model.current_weight
                <= post_user_profile_model.desired_weight
            ):
                raise HTTPException(
                    detail="desired weight must be less than current weight",
                    status_code=400,
                )
            if TDEE < 1200:
                MCI = TDEE
            elif 1200 <= TDEE < 1400:
                MCI = 1200
            elif 1400 <= TDEE < 1800:
                MCI = TDEE - 200
            elif 1800 <= TDEE < 1900:
                MCI = TDEE - 300
            elif 1900 <= TDEE < 2000:
                MCI = TDEE - 400
            elif 2000 <= TDEE < 2100:
                MCI = TDEE - 500
            elif 2100 <= TDEE < 2200:
                MCI = TDEE - 600
            elif 2200 <= TDEE < 2300:
                MCI = TDEE - 700
            elif 2300 <= TDEE < 2400:
                MCI = TDEE - 800
            elif 2400 <= TDEE < 2500:
                MCI = TDEE - 900
            elif 2500 <= TDEE < 2600:
                MCI = TDEE - 1000
            elif TDEE >= 2600:
                MCI = TDEE - 1100

        post_user_profile_model.maximum_calorie_intake = MCI
        model = UserProfile(**post_user_profile_model.dict(exclude_unset=True))
        model.starting_weight = model.current_weight
        session.add(model)
        await session.commit()
        return model
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(detail=f"{error}", status_code=400) from error
