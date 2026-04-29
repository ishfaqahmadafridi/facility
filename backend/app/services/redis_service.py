"""
app/services/redis_service.py
──────────────────────────────────────────────────────────────────
Redis wrappers specifically for Geo-spatial operations and Pub/Sub.
"""
from typing import List, Dict, Any
from app.db.redis import redis_client

class RedisGeoService:
    @staticmethod
    async def add_location(vertical: str, user_id: str, lat: float, lng: float):
        """
        Adds or updates a user's location in a geo set specific to their vertical.
        e.g., Key: `geo:providers:RIDE`
        """
        key = f"geo:providers:{vertical}"
        # redis-py async geoadd expects mapping {member: (lon, lat)}
        await redis_client.geoadd(key, (lng, lat, user_id))

    @staticmethod
    async def remove_location(vertical: str, user_id: str):
        """Removes a user from the geo set."""
        key = f"geo:providers:{vertical}"
        await redis_client.zrem(key, user_id)

    @staticmethod
    async def get_nearby(vertical: str, lat: float, lng: float, radius_km: float = 5.0) -> List[Dict[str, Any]]:
        """
        Finds members within a radius and returns their locations and distances.
        """
        key = f"geo:providers:{vertical}"
        # geosearch returns a list of (member, distance, (lon, lat)) depending on arguments
        results = await redis_client.geosearch(
            key, 
            longitude=lng, latitude=lat, 
            radius=radius_km, unit="km",
            withdist=True, withcoord=True,
            sort="ASC"
        )
        
        nearby = []
        for member, dist, coord in results:
            nearby.append({
                "user_id": member.decode('utf-8') if isinstance(member, bytes) else member,
                "distance_km": dist,
                "lat": coord[1],
                "lng": coord[0]
            })
        return nearby
