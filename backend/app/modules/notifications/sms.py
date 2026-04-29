"""
app/modules/notifications/sms.py
──────────────────────────────────────────────────────────────────
Interface for sending SMS notifications via Twilio or local gateways.
"""

class SMSGateway:
    @staticmethod
    async def send_sms(phone_number: str, message: str) -> bool:
        """
        Sends an SMS message.
        In a production app, this would use the Twilio SDK or a local Pakistani gateway
        like JazzCash SMS API, Telenor API, etc.
        """
        # Mock implementation
        print(f"[SMS Gateway] Sending to {phone_number}: {message}")
        
        # Example Twilio Implementation:
        # client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)
        # message = client.messages.create(
        #     body=message,
        #     from_=settings.TWILIO_PHONE_NUMBER,
        #     to=phone_number
        # )
        
        return True
