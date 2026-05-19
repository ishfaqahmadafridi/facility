"""
app/modules/bookings/service.py
──────────────────────────────────────────────────────────────────
Business logic for Home Services Bookings.
"""
import uuid
import asyncio
from geoalchemy2.elements import WKTElement

from app.modules.bookings.repository import BookingRepository
from app.modules.bookings.models import Booking
from app.modules.bookings.schemas import BookingCreateRequest
from app.modules.bookings.state_machine import BookingStateMachine
from app.common.exceptions import NotFoundException, ConflictException

class BookingService:
    def __init__(self, repo: BookingRepository):
        self.repo = repo

    async def request_booking(self, customer_id: uuid.UUID, data: BookingCreateRequest) -> Booking:
        location_wkt = WKTElement(f'POINT({data.lng} {data.lat})', srid=4326)

        booking = Booking(
            customer_id=customer_id,
            vertical=data.vertical,
            service_type=data.service_type,
            location=location_wkt,
            address=data.address,
            price=data.price,
            notes=data.notes,
            scheduled_for=data.scheduled_for,
            status="SEARCHING"
        )
        booking = await self.repo.create_booking(booking)

        # Broadcast to nearby providers in that vertical (Medical/Repair)
        from app.modules.matching.engine import MatchingEngine
        asyncio.create_task(
            MatchingEngine.match_and_broadcast(
                ride_id=booking.id, # Reusing matching engine
                vertical=data.vertical,
                lat=data.lat,
                lng=data.lng
            )
        )
        return booking

    async def get_booking(self, booking_id: uuid.UUID) -> Booking:
        booking = await self.repo.get_by_id(booking_id)
        if not booking:
            raise NotFoundException("Booking not found")
        return booking

    async def accept_booking(self, provider_id: uuid.UUID, booking_id: uuid.UUID) -> Booking:
        booking = await self.get_booking(booking_id)
        
        if booking.status != "SEARCHING":
            raise ConflictException("Booking is no longer available")

        BookingStateMachine.validate_transition(booking.status, "ACCEPTED")

        booking = await self.repo.update_booking(booking, {
            "status": "ACCEPTED",
            "provider_id": provider_id
        })
        
        # Notify customer
        from app.ws.booking_gateway import emit_booking_accepted
        await emit_booking_accepted(booking.customer_id, booking)

        return booking

    async def update_status(self, provider_id: uuid.UUID, booking_id: uuid.UUID, status: str) -> Booking:
        booking = await self.get_booking(booking_id)
        
        if booking.provider_id != provider_id:
            raise ConflictException("Unauthorized")

        BookingStateMachine.validate_transition(booking.status, status)

        booking = await self.repo.update_booking(booking, {"status": status})
        
        # Notify customer of status change
        from app.ws.booking_gateway import emit_booking_status_update
        await emit_booking_status_update(booking.customer_id, booking)

        return booking
