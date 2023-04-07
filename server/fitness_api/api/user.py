from fastapi import APIRouter, Depends, Request, Response, status
from typing import Any, Dict, List, Union

from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.user import PostUserModel, UserModel, LoginUserModel
from fitness_api import ctrl


PREFIX = "users"
TAGS = ["users"]
router = APIRouter()

LOGIN_USER_STATUS_CODE: Dict[Union[int, str], Dict[str, Any]] = {
    200: {"description": "Login successfully"},
    401: {"description": "Login failed 1"},
}

@router.post("", response_model=UserModel, summary="Create a user", status_code=201)
async def get_user(
    post_user_model: PostUserModel,
    request: Request,
    response: Response,
    session: AsyncSession = Depends(create_session),
) -> UserModel:
    user_record = await ctrl.user.create_user(post_user_model, session)
    user = UserModel.from_orm(user_record).dict()
    return user


@router.post("/login", responses=LOGIN_USER_STATUS_CODE, status_code=status.HTTP_200_OK)
async def login(
    login_user_model: LoginUserModel,
    request: Request,
    response: Response,
    session: AsyncSession = Depends(create_session),
) -> Response:
    print(login_user_model.dict())
    response = await ctrl.user.login(login_user_model, session, response)
    return response