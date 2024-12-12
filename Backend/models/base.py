from sqlalchemy import Column, Integer, DateTime
from sqlalchemy.ext.declarative import as_declarative
from datetime import datetime


@as_declarative()
class Base:
    id = Column(Integer, primary_key=True, index=True)
    created_at = Column(DateTime, default=datetime.now)
    updated_at = Column(DateTime, default=datetime.now, onupdate=datetime.now)
