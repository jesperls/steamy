from pydantic import BaseModel
from typing import Optional, List


class UserBase(BaseModel):
    email: str
    display_name: str
    bio: Optional[str] = None
    preferences: Optional[str] = None
    location_lat: Optional[float] = None
    location_lon: Optional[float] = None


class UserCreate(UserBase):
    password: str


class UserLogin(BaseModel):
    email: str
    password: str


class UserUpdate(BaseModel):
    email: Optional[str] = None
    display_name: Optional[str] = None
    bio: Optional[str] = None
    preferences: Optional[str] = None
    profile_pic: Optional[str] = None
    location_lat: Optional[float] = None
    location_lon: Optional[float] = None


class UserPicture(BaseModel):
    id: int
    user_id: int
    picture_url: str
    is_profile_picture: bool


class UserInterest(BaseModel):
    id: int
    user_id: int
    interest: str


class Match(BaseModel):
    id: int
    user_id_1: int
    user_id_2: int
    match_score: float
    is_matched: bool


class Message(BaseModel):
    id: int
    match_id: int
    sender_id: int
    message_text: str


class MessageCreate(BaseModel):
    match_id: int
    sender_id: int
    message_text: str


class MatchAction(BaseModel):
    matcher_id: int
    matched_id: int
