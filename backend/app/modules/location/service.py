"""
app/modules/location/service.py
──────────────────────────────────────────────────────────────────
Business logic for Location updates.
"""
from typing import List, Dict, Any
from app.services.redis_service import RedisGeoService
from app.modules.location.schemas import LocationUpdatePayload

class LocationService:
    @staticmethod
    async def update_provider_location(user_id: str, data: LocationUpdatePayload):
        """Updates provider location in Redis Geo."""
        await RedisGeoService.add_location(
            vertical=data.vertical,
            user_id=user_id,
            lat=data.lat,
            lng=data.lng
        )
        # We could also trigger a background task here to update Postgres 
        # if we want historical tracking, but Redis is the SSOT for live matching.

    @staticmethod
    async def get_nearby_providers(vertical: str, lat: float, lng: float, radius_km: float = 5.0) -> List[Dict[str, Any]]:
        """Finds nearby providers."""
        return await RedisGeoService.get_nearby(vertical, lat, lng, radius_km)

    @staticmethod
    async def remove_provider_location(user_id: str, vertical: str):
        """Removes a provider from the live map."""
        await RedisGeoService.remove_location(vertical, user_id)
