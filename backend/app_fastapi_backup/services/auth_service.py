from app.crud.repositories import UserRepository
from app.core import otp, security, email_utils
from app.core.config import settings
from datetime import datetime, timedelta

class AuthService:
    def __init__(self, user_repo: UserRepository):
        self.user_repo = user_repo

    async def request_otp(self, email: str):
        code = otp.generate_otp()
        otp.save_otp(email, code)
        
        # Template logic would be here
        template = "Your code is {{ otp }}"
        email_utils.send_email(
            email_to=email,
            subject="Verification Code",
            template=template,
            data={"otp": code}
        )
        return True

    async def verify_otp(self, email: str, code: str):
        stored_otp = otp.get_otp(email)
        if not stored_otp or stored_otp != code:
            return None
        
        user = await self.user_repo.get_by_email(email)
        if not user:
            user_data = {
                "email": email,
                "role": "Customer",
                "is_verified": True,
                "created_at": datetime.utcnow()
            }
            user_id = await self.user_repo.create(user_data)
            user = await self.user_repo.get(user_id)
        
        otp.delete_otp(email)
        
        access_token = security.create_access_token(
            data={"sub": email, "role": user.get("role", "Customer")}
        )
        return access_token
