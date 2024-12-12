from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from .base import Base


class Message(Base):
    __tablename__ = "messages"
    match_id = Column(Integer, ForeignKey("matches.id"))
    sender_id = Column(Integer, ForeignKey("users.id"))
    message_text = Column(String)
    match = relationship("Match", back_populates="messages")
    sender = relationship("User", back_populates="sent_messages")
