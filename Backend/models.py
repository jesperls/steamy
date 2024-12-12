from sqlalchemy import Column, Integer, String, Float, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from .database import Base
from datetime import datetime

# skickar in alla tables här, det är dem jag gjorde i miron
# feel free att ändra på något här ville ba få en vibe för det

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    # username = Column(String, unique=True, index=True) idk nu i efterhand kanske de inte behövs
    email = Column(String, unique=True, index=True)
    password_hash = Column(String) # vi kommer 100 % hasha xxddd
    bio = Column(String)
    preferences = Column(String)
    profile_pic = Column(String) # url ? 
    location_lat = Column(Float)
    location_lon = Column(Float)
    created_at = Column(DateTime, default=datetime.timestamp.utcnow)

class UserPictures(Base):
    __tablename__ = "user_pictures"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    picture_url = Column(String) # url / path kanske
    is_profile_picture = Column(Boolean, default=False) # för messages picen ?
    uploaded_at = Column(DateTime, default=datetime.timestamp.utcnow)

    # ehhh 1-M
    user = relationship("User", back_populates="pictures")

class UserInterest(Base):
    __tablename__ = "user_interests"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    interest = Column(String)
    # tog bort created_at för att det kändes onödigt, osäker på id oxå

    user = relationship("User", back_populates="interests")

class Match(Base):
    __tablename__ = "matches"

    id = Column(Integer, primary_key=True, index=True)
    user_id_1 = Column(Integer, ForeignKey("users.id"))
    user_id_2 = Column(Integer, ForeignKey("users.id"))
    # lmao vi kör väl bara nå bullshit backend algo som jämför intressen för denna
    match_score = Column(Float)
    created_at = Column(DateTime, default=datetime.timestamp.utcnow)

    user_1 = relationship("User", foreign_keys=[user_id_1])
    user_2 = relationship("User", foreign_keys=[user_id_2])

class Message(Base):
    __tablename__ = "messages"

    id = Column(Integer, primary_key=True, index=True)
    match_id = Column(Integer, ForeignKey("matches.id"))
    sender_id = Column(Integer, ForeignKey("users.id"))
    message_text = Column(String)
    timestamp = Column(DateTime, default=datetime.timestamp.utcnow)

    match = relationship("Match", back_populates="messages")
    sender = relationship("User", back_populates="sent_messages")

# relationships :)
User.pictures = relationship("UserPicture", back_populates="user")
User.interests = relationship("UserInterest", back_populates="user")
User.sent_messages = relationship("Message", back_populates="sender")
Match.messages = relationship("Message", back_populates="match")