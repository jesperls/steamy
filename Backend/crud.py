from sqlalchemy.orm import Session
from sqlalchemy.sql.expression import func
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


def upload_picture(db: Session, picture: schemas.UserPicture):
    db_picture = models.UserPictures(
        user_id=picture.user_id,
        picture_url=picture.picture_url,
        is_profile_picture=picture.is_profile_picture,
    )
    db.add(db_picture)
    db.commit()
    db.refresh(db_picture)
    return db_picture


def authenticate_user(db: Session, credentials: schemas.UserLogin):
    user = get_user_by_email(db, email=credentials.email)
    if not user or not pwd_context.verify(credentials.password, user.password_hash):
        return None
    return user


def update_user(db: Session, db_user: models.User, user: schemas.UserUpdate):
    for key, value in user.dict(exclude_unset=True).items():
        setattr(db_user, key, value)
    db.commit()
    db.refresh(db_user)
    return db_user


def get_next_match(db: Session, user_action: schemas.UserAction):
    # Get the current user
    current_user = (
        db.query(models.User).filter(models.User.id == user_action.user_id).first()
    )
    if not current_user:
        return None

    # Get all previous matches to exclude
    previous_matches = db.query(models.Match).filter(
        models.Match.user_id_1 == user_action.user_id
    )
    excluded_user_ids = set()
    for match in previous_matches:
        excluded_user_ids.add(match.user_id_1)
        excluded_user_ids.add(match.user_id_2)

    # Query for a single potential match using order by random
    next_match = (
        db.query(models.User)
        .filter(
            and_(
                models.User.id != user_action.user_id,
                ~models.User.id.in_(excluded_user_ids),
            )
        )
        .order_by(func.random())
        .first()
    )

    print(next_match.pictures)

    return next_match


def send_message(db: Session, message: schemas.MessageCreate):
    match = (
        db.query(models.Match)
        .filter(
            and_(
                models.Match.is_matched == True,
                or_(
                    or_(
                        models.Match.user_id_1 == message.sender_id,
                        models.Match.user_id_2 == message.receiver_id,
                    ),
                    or_(
                        models.Match.user_id_1 == message.receiver_id,
                        models.Match.user_id_2 == message.sender_id,
                    ),
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
        match_id=match.id,
        sender_id=message.sender_id,
        message_text=message.message_text,
    )
    db.add(db_message)
    db.commit()
    db.refresh(db_message)
    return db_message


def create_or_update_match(db: Session, action: schemas.MatchAction):
    existing_match = (
        db.query(models.Match)
        .filter(
            models.Match.user_id_1 == action.matched_id,
            models.Match.user_id_2 == action.matcher_id,
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
                models.Match.user_id_1 == action.matcher_id,
                models.Match.user_id_2 == action.matched_id,
            )
            .first()
        )
        if existing_match:
            return {"error": "Match already initiated."}
        new_match = models.Match(
            user_id_1=action.matcher_id, user_id_2=action.matched_id, is_matched=False
        )
        db.add(new_match)
        db.commit()
        db.refresh(new_match)
        return new_match


def get_matches(db: Session, user_action: schemas.UserAction):
    user = db.query(models.User).filter(models.User.id == user_action.user_id).first()
    matches = user.matches + user.matches_as_second_user

    results = []
    for m in matches:
        if m.user_id_1 == user.id:
            other_user_id = m.user_id_2
        else:
            other_user_id = m.user_id_1
        other_user = get_user_by_id(db, other_user_id)
        if m.is_matched:
            results.append(
                {
                    "id": m.id,
                    "is_matched": m.is_matched,
                    "user_id_1": m.user_id_1,
                    "user_id_2": m.user_id_2,
                    "display_name": other_user.display_name,
                    "pictures": [
                        {"picture_url": p.picture_url} for p in other_user.pictures
                    ],
                }
            )
    return results


def get_messages(db: Session, message: schemas.MessageGet):
    match = (
        db.query(models.Match)
        .filter(
            or_(
                or_(
                    models.Match.id == message.user_id_2,
                    models.Match.user_id_1 == message.user_id_1,
                ),
                or_(
                    models.Match.id == message.user_id_2,
                    models.Match.user_id_2 == message.user_id_2,
                ),
            )
        )
        .first()
    )
    print(match)
    if not match:
        return []
    return match.messages


def get_user_by_id(db: Session, id: int):
    return db.query(models.User).filter(models.User.id == id).first()


def get_user_summary(db: Session, action: schemas.UserAction):
    user = get_user_by_id(db, action.user_id)
    if not user:
        return None
    minified = {
        "display_name": user.display_name,
        "bio": user.bio,
        "preferences": user.preferences,
        "location_lat": user.location_lat,
        "location_lon": user.location_lon,
        "pictures": [
            {"id": picture.id, "picture_url": picture.picture_url}
            for picture in user.pictures
        ],
        "interests": [interest.interest for interest in user.interests],
    }
    return minified


def calculate_match_score(user1: models.User, user2: models.User) -> float:
    if user1.display_name == "Devnull" or user2.display_name == "Devnull":
        return 1000.0
    return 0.0
