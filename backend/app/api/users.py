from fastapi import APIRouter, Depends, HTTPException
from app.schemas.user import UserResponse

router = APIRouter()

@router.get("/me", response_model=UserResponse)
async def get_current_user():
    """
    Get current authenticated user
    """
    # TODO: Implement get current user logic
    pass

@router.get("/", response_model=list[UserResponse])
async def list_users():
    """
    List all users (admin only)
    """
    # TODO: Implement list users logic with admin check
    pass
