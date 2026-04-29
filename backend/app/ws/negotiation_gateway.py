"""
app/ws/negotiation_gateway.py
──────────────────────────────────────────────────────────────────
Socket.IO namespace for live chat between Customer and Driver during Bidding.
"""
import socketio
from typing import Dict, Any

from app.core.security import verify_token
from app.core.socket_server import sio

class NegotiationNamespace(socketio.AsyncNamespace):
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

    async def on_send_message(self, sid, data: Dict[str, Any]):
        """
        Receives a chat message from sender and routes to receiver.
        Payload expects: { "ride_id": uuid, "receiver_id": uuid, "message": "text" }
        """
        session = await self.get_session(sid)
        sender_id = session.get('user_id')
        
        receiver_id = data.get("receiver_id")
        message = data.get("message")
        ride_id = data.get("ride_id")
        
        # Emit to receiver
        await sio.emit(
            'receive_message',
            {
                'ride_id': ride_id,
                'sender_id': sender_id,
                'message': message
            },
            room=str(receiver_id),
            namespace='/negotiation'
        )
