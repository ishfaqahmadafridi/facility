from fastapi import WebSocket
from typing import List, Dict

class ConnectionManager:
    def __init__(self):
        # active_connections: { "request_id": [WebSocket1, WebSocket2] }
        self.active_connections: Dict[str, List[WebSocket]] = {}

    async def connect(self, websocket: WebSocket, request_id: str):
        await websocket.accept()
        if request_id not in self.active_connections:
            self.active_connections[request_id] = []
        self.active_connections[request_id].append(websocket)

    def disconnect(self, websocket: WebSocket, request_id: str):
        if request_id in self.active_connections:
            self.active_connections[request_id].remove(websocket)

    async def broadcast_bid(self, request_id: str, bid_data: dict):
        if request_id in self.active_connections:
            for connection in self.active_connections[request_id]:
                await connection.send_json(bid_data)

manager = ConnectionManager()
