from sqlalchemy.orm import Session
from . import models

# alla defs för login/register/updateProfile/Match etc. 
def create_user(db: Session, user: models.User, ):
    db.add(user)
    db.commit()
    db.refresh(user)
    return user