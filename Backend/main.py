from fastapi import FastAPI

app = FastAPI()


# Register a new user
@app.post("/register")
def register():
    return "AAA"


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
