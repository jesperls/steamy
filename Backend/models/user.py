from sqlalchemy import Column, String, Float
from sqlalchemy.orm import relationship
from .base import Base


class User(Base):
    __tablename__ = "users"
    email = Column(String, unique=True, index=True)
    display_name = Column(String)
    password_hash = Column(String)
    bio = Column(String)
    preferences = Column(String)
    location_lat = Column(Float)
    location_lon = Column(Float)
    pictures = relationship("UserPictures", back_populates="user")
    interests = relationship("UserInterest", back_populates="user")
    sent_messages = relationship("Message", back_populates="sender")
    matches = relationship(
        "Match", back_populates="user_1", foreign_keys="[Match.user_id_1]"
    )
    matches_as_second_user = relationship(
        "Match", back_populates="user_2", foreign_keys="[Match.user_id_2]"
    )
