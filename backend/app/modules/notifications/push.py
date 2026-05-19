"""
app/modules/notifications/push.py
──────────────────────────────────────────────────────────────────
Interface for sending Push Notifications via Firebase Cloud Messaging (FCM).
"""

class FCMGateway:
    @staticmethod
    async def send_push(device_token: str, title: str, body: str, data: dict = None) -> bool:
        """
        Sends a push notification to a specific device via Firebase Admin SDK.
        """
        # Mock implementation
        print(f"[FCM Gateway] Sending Push to {device_token[:10]}... | Title: {title} | Body: {body}")
        
        # Example Firebase Implementation:
        # from firebase_admin import messaging
        # message = messaging.Message(
        #     notification=messaging.Notification(
        #         title=title,
        #         body=body,
        #     ),
        #     data=data or {},
        #     token=device_token,
        # )
        # response = messaging.send(message)
        
        return True
