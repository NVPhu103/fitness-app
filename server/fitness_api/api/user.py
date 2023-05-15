from fastapi import APIRouter, Depends, Request, Response, status
from typing import Any, Dict, List, Union

from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.user import PostUserModel, UserModel, LoginUserModel, UserRole
from fitness_api import ctrl
from fitness_api.schemas.user_profile import UserProfileModel


PREFIX = "users"
TAGS = ["users"]
router = APIRouter()

LOGIN_USER_STATUS_CODE: Dict[Union[int, str], Dict[str, Any]] = {
    200: {"description": "Login successfully"},
    401: {"description": "Login failed 1"},
}


@router.post("", response_model=UserModel, summary="Create a user", status_code=201)
async def create_user(
    post_user_model: PostUserModel,
    request: Request,
    response: Response,
    session: AsyncSession = Depends(create_session),
) -> UserModel:
    user_record = await ctrl.user.create_user(post_user_model, session)
    user = UserModel.from_orm(user_record).dict()
    return user


@router.post(
    "/login",
    response_model=Dict[str, Any],
    responses=LOGIN_USER_STATUS_CODE,
    status_code=status.HTTP_200_OK,
)
async def login(
    login_user_model: LoginUserModel,
    request: Request,
    response: Response,
    session: AsyncSession = Depends(create_session),
) -> Dict[str, Any]:
    user_model = await ctrl.user.login(login_user_model, session)
    user_profile_record = await ctrl.user_profile.get_user_profile(
        session, user_model.id
    )
    user_profile_model = None
    if user_profile_record:
        user_profile_model = UserProfileModel.from_orm(user_profile_record).dict(
            by_alias=True
        )
        response.status_code = status.HTTP_202_ACCEPTED
    user_model_dict = user_model.dict(by_alias=True)
    user_model_dict.update({"userProfile": user_profile_model})
    return user_model_dict
