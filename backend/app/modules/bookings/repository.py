"""
app/modules/bookings/repository.py
──────────────────────────────────────────────────────────────────
Database operations for Bookings.
"""
import uuid
from typing import Optional, List
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from geoalchemy2.elements import WKTElement

from app.modules.bookings.models import Booking

class BookingRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def create_booking(self, booking: Booking) -> Booking:
        self.session.add(booking)
        await self.session.flush()
        return booking

    async def get_by_id(self, booking_id: uuid.UUID) -> Optional[Booking]:
        stmt = select(Booking).where(Booking.id == booking_id, Booking.deleted_at.is_(None))
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def update_booking(self, booking: Booking, update_data: dict) -> Booking:
        for key, value in update_data.items():
            if value is not None:
                setattr(booking, key, value)
        await self.session.flush()
        return booking
