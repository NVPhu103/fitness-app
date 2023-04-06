from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError, NoResultFound
from sqlalchemy import select, func


from fastapi import HTTPException, Response
from fastapi.exception_handlers import http_exception_handler
from fitness_api.schemas.user import PostUserModel, LoginUserModel
from fitness_api.db.model import User



async def create_user(post_user_model: PostUserModel, session: AsyncSession) -> User:
    try:
        if post_user_model.hashed_password == post_user_model.confirm_hashed_password:
            field_exclude = {"confirm_hashed_password"}
            model = User(**post_user_model.dict(exclude_unset=True, exclude=field_exclude))
            session.add(model)
            await session.commit()
            return model
        else:
            raise HTTPException(detail="Confirm password is incorrect", status_code=400)
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(detail="User already exists", status_code=409) from error


async def login(login_user_model: LoginUserModel, session: AsyncSession, response: Response) -> Response:
    try:
        statement = select(User).filter(func.lower(User.username) == func.lower(login_user_model.username))
        user_record = (await session.execute(statement)).scalar_one()
        if login_user_model.password == user_record.hashed_password:
            response.status_code = 200
        else:
            response.status_code = 401
        return response
    except NoResultFound:
        raise HTTPException(detail="Username is invalid", status_code=404)
    except Exception as error:
        raise HTTPException(detail="Login failed", status_code=400) from error
    