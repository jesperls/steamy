from pydantic import BaseModel
from typing import Optional


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


class UserAction(BaseModel):
    user_id: int


class NewMatchAction(UserAction):
    excluded_matches: list


class UserUpdate(BaseModel):
    id: int
    email: Optional[str] = None
    display_name: Optional[str] = None
    bio: Optional[str] = None
    preferences: Optional[str] = None
    profile_pic: Optional[str] = None
    location_lat: Optional[float] = None
    location_lon: Optional[float] = None


class UserPicture(BaseModel):
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
    sender_id: int
    receiver_id: int
    message_text: str


class MessageGet(BaseModel):
    user_id_1: int
    user_id_2: int


class MatchAction(BaseModel):
    matcher_id: int
    matched_id: int
