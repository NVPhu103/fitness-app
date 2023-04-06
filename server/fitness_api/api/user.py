from fastapi import APIRouter, Depends, Request, Response
from typing import List

from sqlalchemy.ext.asyncio import AsyncSession
from fitness_api.db.depends import create_session
from fitness_api.schemas.user import PostUserModel, UserModel

PREFIX = "users"
TAGS = ["users"]
router = APIRouter()


@router.post("", response_model=UserModel, summary="Create a user", status_code=201)
async def get_user(
    user: PostUserModel,
    request: Request,
    response: Response,
    session: AsyncSession = Depends(create_session),
) -> UserModel:
    return "success"
