"""
app/ws/booking_gateway.py
──────────────────────────────────────────────────────────────────
Socket.IO namespace for Home Services Bookings.
"""
import uuid
import socketio

from app.core.security import verify_token
from app.core.socket_server import sio

class BookingNamespace(socketio.AsyncNamespace):
    async def on_connect(self, sid, environ, auth):
        if not auth or 'token' not in auth:
            return False

        payload = verify_token(auth['token'])
        if not payload:
            return False

        user_id = payload.get('sub')
        await self.save_session(sid, {'user_id': user_id})
        self.enter_room(sid, str(user_id))
        return True

    async def on_disconnect(self, sid):
        pass

# ── Standalone Emitters ───────────────────────────────────────────

async def emit_booking_accepted(customer_id: uuid.UUID, booking):
    """Notifies the customer that a provider accepted the booking."""
    await sio.emit(
        'booking_accepted',
        {'booking_id': str(booking.id), 'provider_id': str(booking.provider_id)},
        room=str(customer_id),
        namespace='/booking'
    )

async def emit_booking_status_update(customer_id: uuid.UUID, booking):
    """Notifies the customer of status changes (e.g., EN_ROUTE, COMPLETED)."""
    await sio.emit(
        'booking_status_update',
        {'booking_id': str(booking.id), 'status': booking.status},
        room=str(customer_id),
        namespace='/booking'
    )
