"""
app/ws/ride_gateway.py
──────────────────────────────────────────────────────────────────
Socket.IO namespace for Ride matching and status updates.
"""
import uuid
import socketio

from app.core.security import verify_token
from app.core.socket_server import sio

class RideNamespace(socketio.AsyncNamespace):
    async def on_connect(self, sid, environ, auth):
        if not auth or 'token' not in auth:
            return False

        payload = verify_token(auth['token'])
        if not payload:
            return False

        user_id = payload.get('sub')
        await self.save_session(sid, {'user_id': user_id, 'roles': payload.get('roles', [])})
        
        # Join a room specific to this user so we can target them
        self.enter_room(sid, str(user_id))
        print(f"[WS] Client {sid} connected to /ride (User: {user_id})")
        return True

    async def on_disconnect(self, sid):
        print(f"[WS] Client {sid} disconnected from /ride")

# ── Standalone Emitters ───────────────────────────────────────────

async def broadcast_ride_request(ride_id: uuid.UUID, provider_ids: list[str]):
    """Sends a new ride request to the top N matched providers."""
    for provider_id in provider_ids:
        # Emit to the provider's specific room
        await sio.emit(
            'new_ride_request', 
            {'ride_id': str(ride_id)}, 
            room=str(provider_id),
            namespace='/ride'
        )

async def emit_bid_to_customer(customer_id: uuid.UUID, bid):
    """Sends a new bid to the customer."""
    await sio.emit(
        'new_bid', 
        {
            'bid_id': str(bid.id),
            'driver_id': str(bid.driver_id),
            'bid_amount': float(bid.bid_amount)
        },
        room=str(customer_id),
        namespace='/ride'
    )

async def emit_ride_accepted(driver_id: uuid.UUID, ride):
    """Notifies the winning driver that their bid was accepted."""
    await sio.emit(
        'ride_accepted',
        {'ride_id': str(ride.id)},
        room=str(driver_id),
        namespace='/ride'
    )

async def emit_ride_status(user_id: uuid.UUID, ride):
    """Publishes ride status transitions to a specific user."""
    await sio.emit(
        'ride_status',
        {
            'ride_id': str(ride.id),
            'status': ride.status,
            'driver_id': str(ride.driver_id) if ride.driver_id else None,
            'final_price': float(ride.final_price) if ride.final_price is not None else None,
        },
        room=str(user_id),
        namespace='/ride'
    )
