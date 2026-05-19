"""
app/modules/roadside/service.py
──────────────────────────────────────────────────────────────────
Business logic for Roadside Assistance.
"""
import uuid
import asyncio
from geoalchemy2.elements import WKTElement

from app.modules.roadside.repository import RoadsideRepository
from app.modules.roadside.models import RoadsideRequest
from app.modules.roadside.schemas import RoadsideCreateRequest
from app.modules.roadside.emergency_queue import EmergencyQueue
from app.common.exceptions import NotFoundException, ConflictException

class RoadsideService:
    def __init__(self, repo: RoadsideRepository):
        self.repo = repo

    async def request_assistance(self, customer_id: uuid.UUID, data: RoadsideCreateRequest) -> RoadsideRequest:
        location_wkt = WKTElement(f'POINT({data.lng} {data.lat})', srid=4326)

        request = RoadsideRequest(
            customer_id=customer_id,
            issue_type=data.issue_type,
            location=location_wkt,
            address=data.address,
            notes=data.notes,
            status="SEARCHING"
        )
        request = await self.repo.create_request(request)

        # Trigger expanding radius search in background
        asyncio.create_task(
            EmergencyQueue.run_expanding_search(
                request_id=request.id,
                lat=data.lat,
                lng=data.lng,
            )
        )
        return request

    async def get_request(self, request_id: uuid.UUID) -> RoadsideRequest:
        request = await self.repo.get_by_id(request_id)
        if not request:
            raise NotFoundException("Request not found")
        return request

    async def accept_request(self, provider_id: uuid.UUID, request_id: uuid.UUID) -> RoadsideRequest:
        request = await self.get_request(request_id)
        
        if request.status != "SEARCHING":
            raise ConflictException("Request is already accepted by another mechanic")

        request = await self.repo.update_request(request, {
            "status": "ACCEPTED",
            "provider_id": provider_id
        })
        
        # Notify customer
        from app.ws.booking_gateway import emit_booking_accepted
        await emit_booking_accepted(request.customer_id, request) # Reusing booking emitter

        return request

    async def update_status(self, provider_id: uuid.UUID, request_id: uuid.UUID, status: str) -> RoadsideRequest:
        request = await self.get_request(request_id)
        
        if request.provider_id != provider_id:
            raise ConflictException("Unauthorized")

        request = await self.repo.update_request(request, {"status": status})
        
        # Notify customer
        from app.ws.booking_gateway import emit_booking_status_update
        await emit_booking_status_update(request.customer_id, request)

        return request
