"""
app/modules/roadside/repository.py
──────────────────────────────────────────────────────────────────
Database operations for Roadside Assistance.
"""
import uuid
from typing import Optional
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from geoalchemy2.elements import WKTElement

from app.modules.roadside.models import RoadsideRequest

class RoadsideRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def create_request(self, request: RoadsideRequest) -> RoadsideRequest:
        self.session.add(request)
        await self.session.flush()
        return request

    async def get_by_id(self, request_id: uuid.UUID) -> Optional[RoadsideRequest]:
        stmt = select(RoadsideRequest).where(RoadsideRequest.id == request_id, RoadsideRequest.deleted_at.is_(None))
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def update_request(self, request: RoadsideRequest, update_data: dict) -> RoadsideRequest:
        for key, value in update_data.items():
            if value is not None:
                setattr(request, key, value)
        await self.session.flush()
        return request
