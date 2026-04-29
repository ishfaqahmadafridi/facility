"""
app/modules/bookings/router.py
──────────────────────────────────────────────────────────────────
REST endpoints for Bookings.
"""
import uuid
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.postgres import get_db
from app.core.deps import get_current_user
from app.modules.users.models import User
from app.modules.bookings.schemas import BookingCreateRequest, BookingResponseSchema, BookingStatusUpdate
from app.modules.bookings.repository import BookingRepository
from app.modules.bookings.service import BookingService

router = APIRouter(tags=["Bookings"])

def get_booking_service(session: AsyncSession = Depends(get_db)) -> BookingService:
    return BookingService(BookingRepository(session))

@router.post("/bookings", response_model=BookingResponseSchema, status_code=status.HTTP_201_CREATED)
async def request_booking(
    data: BookingCreateRequest,
    current_user: User = Depends(get_current_user),
    service: BookingService = Depends(get_booking_service)
):
    return await service.request_booking(current_user.id, data)

@router.get("/bookings/{booking_id}", response_model=BookingResponseSchema)
async def get_booking(
    booking_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: BookingService = Depends(get_booking_service)
):
    return await service.get_booking(booking_id)

@router.post("/bookings/{booking_id}/accept", response_model=BookingResponseSchema)
async def accept_booking(
    booking_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: BookingService = Depends(get_booking_service)
):
    if "PROVIDER" not in current_user.roles:
        from fastapi import HTTPException
        raise HTTPException(status_code=403, detail="Only providers can accept bookings")
        
    return await service.accept_booking(current_user.id, booking_id)

@router.patch("/bookings/{booking_id}/status", response_model=BookingResponseSchema)
async def update_booking_status(
    booking_id: uuid.UUID,
    data: BookingStatusUpdate,
    current_user: User = Depends(get_current_user),
    service: BookingService = Depends(get_booking_service)
):
    return await service.update_status(current_user.id, booking_id, data.status)
