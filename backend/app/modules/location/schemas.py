"""
app/modules/location/schemas.py
──────────────────────────────────────────────────────────────────
Pydantic schemas for Location payloads via WebSocket.
"""
from pydantic import BaseModel

class LocationUpdatePayload(BaseModel):
    lat: float
    lng: float
    vertical: str  # e.g., RIDE, MEDICAL, ROADSIDE
    heading: float = 0.0

class NearbyQueryPayload(BaseModel):
    lat: float
    lng: float
    vertical: str
    radius_km: float = 5.0
