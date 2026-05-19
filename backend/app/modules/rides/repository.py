"""
app/modules/rides/repository.py
──────────────────────────────────────────────────────────────────
Database operations for Rides.
"""
import uuid
from typing import Optional
from sqlalchemy import select, update
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
from geoalchemy2.elements import WKTElement

from app.modules.rides.models import Ride, RideBid

class RideRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def create_ride(self, ride: Ride) -> Ride:
        self.session.add(ride)
        await self.session.flush()
        return ride

    async def get_by_id(self, ride_id: uuid.UUID) -> Optional[Ride]:
        stmt = (
            select(Ride)
            .options(selectinload(Ride.bids))
            .where(Ride.id == ride_id, Ride.deleted_at.is_(None))
        )
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def update_ride(self, ride: Ride, update_data: dict) -> Ride:
        for key, value in update_data.items():
            if value is not None:
                setattr(ride, key, value)
        await self.session.flush()
        return ride

    async def create_bid(self, bid: RideBid) -> RideBid:
        self.session.add(bid)
        await self.session.flush()
        return bid

    async def get_bid_by_id(self, bid_id: uuid.UUID) -> Optional[RideBid]:
        stmt = select(RideBid).where(RideBid.id == bid_id)
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def update_bid(self, bid: RideBid, status: str) -> RideBid:
        bid.status = status
        await self.session.flush()
        return bid

    async def reject_other_bids(self, ride_id: uuid.UUID, accepted_bid_id: uuid.UUID) -> None:
        stmt = (
            update(RideBid)
            .where(RideBid.ride_id == ride_id, RideBid.id != accepted_bid_id)
            .values(status="REJECTED")
        )
        await self.session.execute(stmt)
        await self.session.flush()
