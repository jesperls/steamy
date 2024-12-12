import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session, Session
import crud, schemas
from models import Base

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./Database/database.db")

os.makedirs(os.path.dirname(DATABASE_URL.split("///")[1]), exist_ok=True)

engine = create_engine(DATABASE_URL)
SessionLocal = scoped_session(
    sessionmaker(autocommit=False, autoflush=False, bind=engine)
)


def init_db():
    Base.metadata.create_all(bind=engine)
    db: Session = SessionLocal()
    try:
        user = crud.get_user_by_email(db, "devnull@darkrage.com")
        if not user:
            devnull_user = schemas.UserCreate(
                email="devnull@darkrage.com",
                display_name="Devnull",
                password="orsismells",
                bio="Meow",
                preferences=None,
                location_lat=None,
                location_lon=None,
            )
            crud.create_user(db, devnull_user)
    finally:
        db.close()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
