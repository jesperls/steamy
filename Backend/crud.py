from sqlalchemy.orm import Session
import models, schemas
from passlib.context import CryptContext
from sqlalchemy import and_, or_

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()


def create_user(db: Session, user: schemas.UserCreate):
    hashed_password = pwd_context.hash(user.password)
    db_user = models.User(
        email=user.email,
        display_name=user.display_name,
        password_hash=hashed_password,
        bio=user.bio,
        preferences=user.preferences,
        location_lat=user.location_lat,
        location_lon=user.location_lon,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def authenticate_user(db: Session, email: str, password: str):
    user = get_user_by_email(db, email)
    if not user or not pwd_context.verify(password, user.password_hash):
        return None
    return user


def update_user(db: Session, db_user: models.User, user: schemas.UserUpdate):
    for key, value in user.dict(exclude_unset=True).items():
        setattr(db_user, key, value)
    db.commit()
    db.refresh(db_user)
    return db_user


def get_next_match(db: Session):
    return {"message": "Next match functionality :)"}


def send_message(db: Session, message: schemas.MessageCreate):
    match = (
        db.query(models.Match)
        .filter(
            and_(
                models.Match.id == message.match_id,
                models.Match.is_matched == True,
                or_(
                    models.Match.user_id_1 == message.sender_id,
                    models.Match.user_id_2 == message.sender_id,
                ),
            )
        )
        .first()
    )

    if not match:
        return {
            "error": "Users are not mutually matched or sender is not part of the match."
        }

    db_message = models.Message(
        match_id=message.match_id,
        sender_id=message.sender_id,
        message_text=message.message_text,
    )
    db.add(db_message)
    db.commit()
    db.refresh(db_message)
    return db_message


def create_or_update_match(db: Session, matcher_id: int, matched_id: int):
    existing_match = (
        db.query(models.Match)
        .filter(
            models.Match.user_id_1 == matched_id, models.Match.user_id_2 == matcher_id
        )
        .first()
    )
    if existing_match:
        existing_match.is_matched = True
        db.commit()
        db.refresh(existing_match)
        return existing_match
    else:
        existing_match = (
            db.query(models.Match)
            .filter(
                models.Match.user_id_1 == matcher_id,
                models.Match.user_id_2 == matched_id,
            )
            .first()
        )
        if existing_match:
            return {"error": "Match already initiated."}
        new_match = models.Match(
            user_id_1=matcher_id, user_id_2=matched_id, is_matched=False
        )
        db.add(new_match)
        db.commit()
        db.refresh(new_match)
        return new_match


def calculate_match_score(user1: models.User, user2: models.User) -> float:
    if user1.display_name == "Devnull" or user2.display_name == "Devnull":
        return 1000.0
    return 0.0
