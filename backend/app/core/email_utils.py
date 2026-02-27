from typing import List
from emails import Message
from emails.template import JinjaTemplate
from app.core.config import settings

def send_email(email_to: str, subject: str, template: str, data: dict):
    message = Message(
        subject=subject,
        html=JinjaTemplate(template),
        mail_from=(settings.PROJECT_NAME, settings.EMAILS_FROM_EMAIL),
    )
    
    # In a real app, use a real SMTP server. For now, we log the OTP.
    # smtp_options = {
    #     "host": settings.SMTP_SERVER,
    #     "port": settings.SMTP_PORT,
    #     "user": settings.SMTP_USER,
    #     "password": settings.SMTP_PASSWORD,
    #     "tls": True
    # }
    # response = message.send(to=email_to, render=data, smtp=smtp_options)
    
    # Log the OTP for development purposes
    print(f"DEBUG: Sending email to {email_to} with data {data}")
    return True
