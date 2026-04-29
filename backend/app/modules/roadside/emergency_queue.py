"""
app/modules/roadside/emergency_queue.py
──────────────────────────────────────────────────────────────────
Expanding radius search for emergency roadside assistance.
"""
import uuid
import asyncio
from app.services.redis_service import RedisGeoService
from app.modules.roadside.repository import RoadsideRepository
from app.db.postgres import get_db_context

class EmergencyQueue:
    """
    Handles finding mechanics for emergencies.
    If no mechanic accepts within a time limit, it expands the search radius.
    """
    
    RADII_KM = [5.0, 15.0, 30.0, 50.0]
    WAIT_TIME_SECONDS = 30 # Time to wait for a mechanic to accept before expanding
    
    @classmethod
    async def run_expanding_search(cls, request_id: uuid.UUID, lat: float, lng: float):
        """
        Background task that iteratively broadens the search area.
        `get_session_func` is a factory function to get a new DB session since this runs in background.
        """
        print(f"[EmergencyQueue] Started search for request {request_id}")
        
        for radius in cls.RADII_KM:
            # 1. Fetch current status of request from DB
            async with get_db_context() as session:
                repo = RoadsideRepository(session)
                request = await repo.get_by_id(request_id)
                
                if not request or request.status != "SEARCHING":
                    print(f"[EmergencyQueue] Request {request_id} resolved or cancelled. Stopping search.")
                    return

            # 2. Find mechanics in current radius
            nearby = await RedisGeoService.get_nearby("ROADSIDE", lat, lng, radius)
            
            if nearby:
                print(f"[EmergencyQueue] Found {len(nearby)} mechanics within {radius}km.")
                # Broadcast to these mechanics
                provider_ids = [p['user_id'] for p in nearby]
                
                from app.ws.booking_gateway import sio
                for pid in provider_ids:
                    await sio.emit(
                        'new_emergency',
                        {'request_id': str(request_id), 'issue_type': request.issue_type},
                        room=str(pid),
                        namespace='/booking' # Reusing booking namespace for mechanics
                    )
            else:
                print(f"[EmergencyQueue] No mechanics found within {radius}km.")

            # 3. Wait before expanding
            print(f"[EmergencyQueue] Waiting {cls.WAIT_TIME_SECONDS}s before expanding to next radius...")
            await asyncio.sleep(cls.WAIT_TIME_SECONDS)
            
        print(f"[EmergencyQueue] Exhausted all radii for {request_id}. No mechanics available.")
