from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
import crud, db_manager
from schemas import UserCreate, UserLogin, UserUpdate, MessageCreate, MatchAction

app = FastAPI()

# Initialize the database
db_manager.init_db()


# Get the database session
def get_db():
    yield from db_manager.get_db()


# Register a new user
@app.post("/register")
def register(user: UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db=db, user=user)


# User login
@app.post("/login")
def login(user: UserLogin, db: Session = Depends(get_db)):
    db_user = crud.authenticate_user(db, email=user.email, password=user.password)
    if not db_user:
        raise HTTPException(status_code=400, detail="Invalid credentials")
    return {"message": "Login successful"}


# Update user profile without token dependency
@app.put("/updateProfile")
def update_profile(user: UserUpdate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    return crud.update_user(db=db, db_user=db_user, user=user)


# Get next match
@app.get("/getNextMatch")
def get_next_match(db: Session = Depends(get_db)):
    return crud.get_next_match(db=db)


# Send a message
@app.post("/sendMessage")
def send_message(message: MessageCreate, db: Session = Depends(get_db)):
    result = crud.send_message(db=db, message=message)
    if isinstance(result, dict) and "error" in result:
        raise HTTPException(status_code=400, detail=result["error"])
    return {"message": "Message sent successfully", "data": result}


# Match users
@app.post("/match")
def match_users(action: MatchAction, db: Session = Depends(get_db)):
    match = crud.create_or_update_match(
        db=db, matcher_id=action.matcher_id, matched_id=action.matched_id
    )
    if isinstance(match, dict) and "error" in match:
        raise HTTPException(status_code=400, detail=match["error"])
    if match.is_matched:
        return {"message": "It's a mutual match!", "match_id": match.id}
    else:
        return {"message": "Match request sent."}
