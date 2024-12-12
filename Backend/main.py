from fastapi import FastAPI
from . import models, crud, database

app = FastAPI()
models.Base.metadata.create_all(bind=database.engine)

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Register a new user
@app.post("/register")
def register( db: Session = Depends(get_db)): # ish ? 
    return "AAA"
    # return crud.create_user()


# User login
@app.post("/login")
def login():
    return {"message": "Login successful"}


# Update user profile
@app.put("/updateProfile")
def update_profile():
    return "db_profile"


# Get next match
@app.get("/getNextMatch")
def get_next_match():
    return "next_match"
