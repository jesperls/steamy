from sqlalchemy import Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from .base import Base


class UserPictures(Base):
    __tablename__ = "user_pictures"
    user_id = Column(Integer, ForeignKey("users.id"))
    picture_url = Column(String)
    is_profile_picture = Column(Boolean, default=False)
    user = relationship("User", back_populates="pictures")
