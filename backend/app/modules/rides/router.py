"""
app/modules/rides/router.py
──────────────────────────────────────────────────────────────────
REST endpoints for Rides.
"""
import uuid
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.postgres import get_db
from app.core.deps import get_current_user
from app.modules.users.models import User
from app.modules.rides.schemas import RideCreateRequest, RideResponseSchema, BidCreateRequest, BidResponseSchema
from app.modules.rides.repository import RideRepository
from app.modules.rides.service import RideService

router = APIRouter(tags=["Rides"])

def get_ride_service(session: AsyncSession = Depends(get_db)) -> RideService:
    return RideService(RideRepository(session))


@router.post("/rides", response_model=RideResponseSchema, status_code=status.HTTP_201_CREATED)
async def request_ride(
    data: RideCreateRequest,
    current_user: User = Depends(get_current_user),
    service: RideService = Depends(get_ride_service)
):
    return await service.request_ride(current_user.id, data)


@router.get("/rides/{ride_id}", response_model=RideResponseSchema)
async def get_ride(
    ride_id: uuid.UUID,
    current_user: User = Depends(get_current_user), # Just ensuring auth
    service: RideService = Depends(get_ride_service)
):
    return await service.get_ride(ride_id)


@router.post("/rides/bids", response_model=BidResponseSchema, status_code=status.HTTP_201_CREATED)
async def place_bid(
    data: BidCreateRequest,
    current_user: User = Depends(get_current_user),
    service: RideService = Depends(get_ride_service)
):
    # Ensure current_user is a PROVIDER
    if "PROVIDER" not in current_user.roles:
        from fastapi import HTTPException
        raise HTTPException(status_code=403, detail="Only providers can place bids")
        
    return await service.place_bid(current_user.id, data)


@router.post("/rides/{ride_id}/bids/{bid_id}/accept", response_model=RideResponseSchema)
async def accept_bid(
    ride_id: uuid.UUID,
    bid_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: RideService = Depends(get_ride_service)
):
    return await service.accept_bid(current_user.id, ride_id, bid_id)
