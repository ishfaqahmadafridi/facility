"""
app/main.py
──────────────────────────────────────────────────────────────────
Main application entry point. 
Combines FastAPI with python-socketio ASGI handler.
"""
import socketio
from fastapi import FastAPI

from app.core.app_factory import create_app
from app.core.socket_server import sio
from app.ws.location_gateway import LocationNamespace
from app.ws.ride_gateway import RideNamespace
from app.ws.negotiation_gateway import NegotiationNamespace
from app.ws.booking_gateway import BookingNamespace

# 1. Create FastAPI application
fastapi_app = create_app()

# 2. Register Namespaces
sio.register_namespace(LocationNamespace('/location'))
sio.register_namespace(RideNamespace('/ride'))
sio.register_namespace(NegotiationNamespace('/negotiation'))
sio.register_namespace(BookingNamespace('/booking'))

# 3. Wrap FastAPI with Socket.IO ASGI application
app = socketio.ASGIApp(sio, other_asgi_app=fastapi_app)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
