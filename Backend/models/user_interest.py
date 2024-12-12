from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from .base import Base


class UserInterest(Base):
    __tablename__ = "user_interests"
    user_id = Column(Integer, ForeignKey("users.id"))
    interest = Column(String)
    user = relationship("User", back_populates="interests")
