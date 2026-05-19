"""
app/modules/rides/service.py
──────────────────────────────────────────────────────────────────
Business logic for Rides and Bidding.
"""
import uuid
import asyncio
from geoalchemy2.elements import WKTElement

from app.modules.rides.repository import RideRepository
from app.modules.rides.models import Ride, RideBid
from app.modules.rides.schemas import RideCreateRequest, BidCreateRequest
from app.modules.rides.state_machine import RideStateMachine
from app.modules.matching.engine import MatchingEngine
from app.common.exceptions import NotFoundException, ConflictException

class RideService:
    def __init__(self, repo: RideRepository):
        self.repo = repo

    async def request_ride(self, customer_id: uuid.UUID, data: RideCreateRequest) -> Ride:
        pickup_wkt = WKTElement(f'POINT({data.pickup.lng} {data.pickup.lat})', srid=4326)
        dropoff_wkt = WKTElement(f'POINT({data.dropoff.lng} {data.dropoff.lat})', srid=4326)

        ride = Ride(
            customer_id=customer_id,
            pickup_location=pickup_wkt,
            dropoff_location=dropoff_wkt,
            pickup_address=data.pickup.address,
            dropoff_address=data.dropoff.address,
            ride_type=data.ride_type,
            estimated_price=data.estimated_price,
            distance_km=data.distance_km,
            status="REQUESTED"
        )
        ride = await self.repo.create_ride(ride)

        ride = await self.repo.update_ride(ride, {"status": "BROADCASTING"})

        # Trigger matching engine asynchronously
        asyncio.create_task(
            MatchingEngine.match_and_broadcast(
                ride_id=ride.id,
                vertical="RIDE",
                lat=data.pickup.lat,
                lng=data.pickup.lng
            )
        )
        return ride

    async def get_ride(self, ride_id: uuid.UUID) -> Ride:
        ride = await self.repo.get_by_id(ride_id)
        if not ride:
            raise NotFoundException("Ride not found")
        return ride

    async def place_bid(self, driver_id: uuid.UUID, data: BidCreateRequest) -> RideBid:
        ride = await self.get_ride(data.ride_id)
        
        # Ride must be open for negotiation.
        if ride.status not in ["BROADCASTING", "NEGOTIATING"]:
            raise ConflictException("Ride is no longer accepting bids")

        if ride.status == "BROADCASTING":
            await self.repo.update_ride(ride, {"status": "NEGOTIATING"})

        bid = RideBid(
            ride_id=ride.id,
            driver_id=driver_id,
            bid_amount=data.bid_amount
        )
        bid = await self.repo.create_bid(bid)
        
        # Broadcast bid to customer
        from app.ws.ride_gateway import emit_bid_to_customer
        await emit_bid_to_customer(ride.customer_id, bid)
        
        return bid

    async def accept_bid(self, customer_id: uuid.UUID, ride_id: uuid.UUID, bid_id: uuid.UUID) -> Ride:
        ride = await self.get_ride(ride_id)
        if ride.customer_id != customer_id:
            raise ConflictException("Unauthorized")
            
        RideStateMachine.validate_transition(ride.status, "MATCHED")

        bid = await self.repo.get_bid_by_id(bid_id)
        if not bid or bid.ride_id != ride.id:
            raise NotFoundException("Bid not found")

        # Update Ride
        ride = await self.repo.update_ride(ride, {
            "status": "MATCHED",
            "driver_id": bid.driver_id,
            "final_price": bid.bid_amount
        })
        RideStateMachine.validate_transition(ride.status, "CONFIRMED")
        ride = await self.repo.update_ride(ride, {"status": "CONFIRMED"})
        
        # Accept the bid, reject others implicitly or explicitly
        await self.repo.update_bid(bid, "ACCEPTED")
        await self.repo.reject_other_bids(ride.id, bid.id)

        # Notify driver
        from app.ws.ride_gateway import emit_ride_accepted, emit_ride_status
        await emit_ride_accepted(bid.driver_id, ride)
        await emit_ride_status(ride.customer_id, ride)

        return ride
