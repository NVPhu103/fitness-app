from asyncio import current_task
from typing import AsyncGenerator

from sqlalchemy.ext.asyncio import AsyncSession, async_scoped_session

from fitness_api.config import async_session_factory


async def create_session() -> AsyncGenerator[AsyncSession, None]:  # pragma: no cover
    Session = async_scoped_session(async_session_factory, scopefunc=current_task)
    async with Session() as session:
        yield session

