# match.py
from sqlalchemy import Column, Integer, Float, ForeignKey, Boolean, UniqueConstraint
from sqlalchemy.orm import relationship
from .base import Base


class Match(Base):
    __tablename__ = "matches"
    user_id_1 = Column(Integer, ForeignKey("users.id"))
    user_id_2 = Column(Integer, ForeignKey("users.id"), nullable=True)
    match_score = Column(Float)
    is_matched = Column(Boolean, default=False)
    messages = relationship("Message", back_populates="match")
    user_1 = relationship("User", back_populates="matches", foreign_keys=[user_id_1])
    user_2 = relationship(
        "User", back_populates="matches_as_second_user", foreign_keys=[user_id_2]
    )
    __table_args__ = (
        UniqueConstraint("user_id_1", "user_id_2", name="unique_user_pair"),
    )
