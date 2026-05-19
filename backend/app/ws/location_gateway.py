"""
app/ws/location_gateway.py
──────────────────────────────────────────────────────────────────
Socket.IO namespace for high-frequency location streaming.
"""
import socketio
from typing import Dict, Any

from app.core.security import verify_token
from app.modules.location.service import LocationService
from app.modules.location.schemas import LocationUpdatePayload, NearbyQueryPayload

class LocationNamespace(socketio.AsyncNamespace):
    
    async def on_connect(self, sid, environ, auth):
        """Authenticates the WebSocket connection."""
        if not auth or 'token' not in auth:
            return False  # Reject connection

        payload = verify_token(auth['token'])
        if not payload:
            return False

        # Store user_id and roles in the session for this socket
        await self.save_session(sid, {
            'user_id': payload.get('sub'),
            'roles': payload.get('roles', [])
        })
        print(f"[WS] Client {sid} connected to /location (User: {payload.get('sub')})")
        return True

    async def on_disconnect(self, sid):
        print(f"[WS] Client {sid} disconnected from /location")
        # In a real app, we might want to mark them offline or remove from geo set
        # if we tracked their active vertical.

    async def on_update_location(self, sid, data: Dict[str, Any]):
        """
        Providers emit this to update their live location.
        """
        session = await self.get_session(sid)
        user_id = session.get('user_id')
        
        # Only providers should be broadcasting their location
        if 'PROVIDER' not in session.get('roles', []):
            return {"status": "error", "message": "Unauthorized"}

        try:
            payload = LocationUpdatePayload(**data)
            await LocationService.update_provider_location(user_id, payload)
            return {"status": "ok"}
        except Exception as e:
            return {"status": "error", "message": str(e)}

    async def on_get_nearby(self, sid, data: Dict[str, Any]):
        """
        Customers emit this to see nearby providers (e.g. cars on map).
        """
        try:
            payload = NearbyQueryPayload(**data)
            providers = await LocationService.get_nearby_providers(
                vertical=payload.vertical,
                lat=payload.lat,
                lng=payload.lng,
                radius_km=payload.radius_km
            )
            
            # We emit the result back to the specific client
            await self.emit('nearby_providers', {'data': providers}, to=sid)
        except Exception as e:
            await self.emit('error', {'message': str(e)}, to=sid)
