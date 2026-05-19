"""
app/core/socket_server.py
──────────────────────────────────────────────────────────────────
Singleton Socket.IO server instance.
"""
import socketio

# Initialize the AsyncServer here to avoid circular imports.
sio = socketio.AsyncServer(async_mode='asgi', cors_allowed_origins="*")
