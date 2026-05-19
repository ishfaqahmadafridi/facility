"""
app/modules/matching/engine.py
──────────────────────────────────────────────────────────────────
Orchestrates finding nearby providers, scoring them, and triggering broadcast.
"""
import uuid
import asyncio
from app.services.redis_service import RedisGeoService
from app.modules.matching.scorer import score_providers

class MatchingEngine:
    @staticmethod
    async def match_and_broadcast(ride_id: uuid.UUID, vertical: str, lat: float, lng: float, radius_km: float = 5.0):
        """
        1. Find nearby providers in Redis
        2. Score and pick Top 10
        3. Emit WebSocket event to those 10 providers
        """
        # 1. GeoQuery
        nearby = await RedisGeoService.get_nearby(vertical, lat, lng, radius_km)
        
        if not nearby:
            print(f"[Matching] No drivers found within {radius_km}km for ride {ride_id}")
            return
            
        # 2. Score
        top_providers = score_providers(nearby)
        print(f"[Matching] Found {len(top_providers)} drivers for ride {ride_id}")
        
        # 3. Broadcast (We will emit via Socket.IO later)
        # Import inside to avoid circular deps
        from app.ws.ride_gateway import broadcast_ride_request
        
        provider_ids = [p['user_id'] for p in top_providers]
        await broadcast_ride_request(ride_id, provider_ids)
