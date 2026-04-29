"""
app/modules/providers/repository.py
──────────────────────────────────────────────────────────────────
Database queries for Provider profiles.
"""
import uuid
from typing import Optional
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from geoalchemy2.elements import WKTElement

from app.modules.providers.models import ProviderProfile

class ProviderRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_by_user_id(self, user_id: uuid.UUID) -> Optional[ProviderProfile]:
        stmt = select(ProviderProfile).where(
            ProviderProfile.user_id == user_id, 
            ProviderProfile.deleted_at.is_(None)
        )
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def create(self, provider: ProviderProfile) -> ProviderProfile:
        self.session.add(provider)
        await self.session.flush()
        return provider

    async def update(self, provider: ProviderProfile, update_data: dict) -> ProviderProfile:
        for key, value in update_data.items():
            if value is not None:
                setattr(provider, key, value)
        await self.session.flush()
        return provider

    async def update_location(self, provider: ProviderProfile, lat: float, lng: float, geo_hash: str):
        # SRID 4326 represents WGS 84 spatial reference system
        point = WKTElement(f'POINT({lng} {lat})', srid=4326)
        provider.location = point
        provider.geo_hash = geo_hash
        await self.session.flush()
        return provider
