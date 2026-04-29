"""
app/modules/auth/repository.py
──────────────────────────────────────────────────────────────────
Database queries for Authentication and User fetching.
"""
import uuid
from typing import Optional
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.modules.users.models import User
from app.modules.auth.models import RefreshToken


class AuthRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_user_by_phone(self, phone: str) -> Optional[User]:
        stmt = select(User).where(User.phone == phone, User.deleted_at.is_(None))
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def get_user_by_id(self, user_id: uuid.UUID) -> Optional[User]:
        stmt = select(User).where(User.id == user_id, User.deleted_at.is_(None))
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def create_user(self, phone: str) -> User:
        user = User(
            phone=phone,
            roles=["CUSTOMER"],
            status="ACTIVE",
        )
        self.session.add(user)
        await self.session.flush()  # To get the ID generated
        return user

    async def save_refresh_token(self, user_id: uuid.UUID, token_hash: str, expires_at) -> RefreshToken:
        rt = RefreshToken(
            user_id=user_id,
            token_hash=token_hash,
            expires_at=expires_at,
        )
        self.session.add(rt)
        await self.session.flush()
        return rt

    async def get_refresh_token(self, token_hash: str) -> Optional[RefreshToken]:
        stmt = select(RefreshToken).where(RefreshToken.token_hash == token_hash)
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()
