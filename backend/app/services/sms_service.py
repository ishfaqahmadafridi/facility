"""
app/services/sms_service.py
──────────────────────────────────────────────────────────────────
SMS Gateway integration.
Supports 'console' for local dev and 'twilio' for production.
"""
import logging
from app.core.config import settings

logger = logging.getLogger(__name__)

# Lazy init for Twilio to prevent crashes if credentials are not set
_twilio_client = None


def _get_twilio_client():
    global _twilio_client
    if _twilio_client is None:
        try:
            from twilio.rest import Client
            _twilio_client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)
        except ImportError:
            logger.error("Twilio SDK not installed. Run: pip install twilio")
    return _twilio_client


async def send_sms(phone_number: str, message: str) -> bool:
    """
    Sends an SMS message.
    If settings.SMS_PROVIDER is 'console', it just prints to the terminal.
    """
    if settings.SMS_PROVIDER == "console":
        print("\n" + "=" * 50)
        print(f"📱 MOCK SMS TO: {phone_number}")
        print(f"✉️  MESSAGE: {message}")
        print("=" * 50 + "\n")
        return True

    elif settings.SMS_PROVIDER == "twilio":
        client = _get_twilio_client()
        if not client:
            return False
            
        try:
            message_obj = client.messages.create(
                body=message,
                from_=settings.TWILIO_PHONE_NUMBER,
                to=phone_number
            )
            logger.info(f"Sent SMS to {phone_number}, SID: {message_obj.sid}")
            return True
        except Exception as e:
            logger.error(f"Failed to send SMS to {phone_number}: {str(e)}")
            return False

    else:
        logger.error(f"Unknown SMS_PROVIDER: {settings.SMS_PROVIDER}")
        return False
