from uuid import UUID
from fastapi import APIRouter, Depends, Request, Response, status, HTTPException
from typing import Any, Dict, List, Optional, Union

from datetime import datetime
from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.user_profile import UserProfileModel, PostUserProfileModel, UserProfileActivityLevel, UserProfileGender
from fitness_api import ctrl

PREFIX = "userprofiles"
TAGS = ["userprofiles"]
router = APIRouter()


@router.get(
    "/{user_id}",
    response_model=Optional[UserProfileModel],
    summary="Get a user profile",
    status_code=200,
)
async def get_food(
    request: Request,
    response: Response,
    user_id: UUID,
    session: AsyncSession = Depends(create_session),
) -> Optional[UserProfileModel]:
    user_profile_record = await ctrl.user_profile.get_user_profile(session, user_id)
    if user_profile_record:
        user_profile = UserProfileModel.from_orm(user_profile_record).dict(
            by_alias=True
        )
        return user_profile
    else:
        raise HTTPException(detail="Not found user profile", status_code=404)


@router.post(
    "",
    response_model=UserProfileModel,
    summary="Create a user profile",
    status_code=201,
)
async def create_user_profile(
    post_user_profile_model: PostUserProfileModel,
    request: Request,
    response: Response,
    session: AsyncSession = Depends(create_session),
) -> UserProfileModel:
    user_profile_record = await ctrl.user_profile.create_user_profile(
        post_user_profile_model, session
    )
    user_profile = UserProfileModel.from_orm(user_profile_record).dict(by_alias=True)
    return user_profile
