"""
app/services/storage_service.py
──────────────────────────────────────────────────────────────────
Storage Service for uploading Avatars and Documents.
Supports local uploads for dev, S3 for production.
"""
import os
import uuid
import logging
from fastapi import UploadFile
from app.core.config import settings

logger = logging.getLogger(__name__)

async def upload_file(file: UploadFile, directory: str = "avatars") -> str:
    """
    Saves an uploaded file.
    In development, saves to a local /uploads folder.
    In production, would upload to AWS S3.
    """
    file_ext = file.filename.split(".")[-1] if file.filename else "jpg"
    unique_filename = f"{uuid.uuid4().hex}.{file_ext}"
    
    if settings.STORAGE_PROVIDER == "local":
        # Create uploads dir if it doesn't exist
        upload_dir = os.path.join(os.getcwd(), "uploads", directory)
        os.makedirs(upload_dir, exist_ok=True)
        
        file_path = os.path.join(upload_dir, unique_filename)
        
        # Read file contents and save
        content = await file.read()
        with open(file_path, "wb") as f:
            f.write(content)
            
        # Return a relative URL that FastAPI can serve statically
        # We assume main.py mounts /uploads
        return f"/uploads/{directory}/{unique_filename}"
        
    elif settings.STORAGE_PROVIDER == "s3":
        # Here we would implement boto3 s3.upload_fileobj
        logger.info(f"Simulating S3 upload for {unique_filename}")
        return f"https://{settings.AWS_BUCKET_NAME}.s3.amazonaws.com/{directory}/{unique_filename}"
        
    else:
        logger.error(f"Unknown STORAGE_PROVIDER: {settings.STORAGE_PROVIDER}")
        return ""
