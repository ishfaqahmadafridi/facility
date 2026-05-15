from fastapi import APIRouter, Depends, HTTPException, status
from app.api.user import get_current_user
from app.db.mongodb import get_database

router = APIRouter(prefix="/governance", tags=["governance"])

async def get_super_admin(current_user = Depends(get_current_user)):
    if current_user.get("role") != "SuperAdmin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access restricted to Super-Admins only"
        )
    return current_user

@router.get("/attestation-queue")
async def get_attestation_queue(
    admin = Depends(get_super_admin),
    db = Depends(get_database)
):
    # Find nurses waiting for HCS verification
    queue = await db.users.find({
        "role": "Nurse",
        "verification_gate.hcs_verified": False
    }).to_list(100)
    return queue

@router.post("/approve-hcs/{user_id}")
async def approve_hcs(
    user_id: str,
    admin = Depends(get_super_admin),
    db = Depends(get_database)
):
    await db.users.update_one(
        {"_id": ObjectId(user_id)},
        {"$set": {"verification_gate.hcs_verified": True}}
    )
    return {"message": "HCS certification approved"}
