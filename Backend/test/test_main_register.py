import pytest
from unittest import mock
from fastapi import HTTPException
from main import register, app
from schemas import UserCreate
from fastapi.testclient import TestClient
from db_manager import get_db
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from models import Base
# docu for exp. outcomes 
# Register route tests

DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture(scope="function")
def test_db():
    Base.metadata.create_all(bind=engine)
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()
        Base.metadata.drop_all(bind=engine)
        Base.metadata.create_all(bind=engine)


@pytest.fixture(scope="function")
def client(test_db):
    def override_get_db():
        yield test_db

    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as c:
        yield c


@pytest.mark.unit
@pytest.fixture
def mock_db_session():
    return mock.Mock()

@pytest.mark.unit
def test_register_success(mock_db_session):
    mock_user = UserCreate(
        email="devnull@darkrage.com",
        display_name="The boy",
        password="securepassword",
        bio="Meow",
        preferences="Suffer",
        location_lat=10.0,
        location_lon=10.0,
    )
    with mock.patch("crud.get_user_by_email", return_value=None) as mock_get_user, \
         mock.patch("crud.create_user", return_value=mock_user) as mock_create_user:
        result = register(user=mock_user, db=mock_db_session)

        assert result == mock_user
        mock_get_user.assert_called_once_with(mock_db_session, email=mock_user.email)
        mock_create_user.assert_called_once_with(db=mock_db_session, user=mock_user)

@pytest.mark.unit
def test_register_existing_user(mock_db_session):
    mock_user = UserCreate(
        email="devnullexists@darkrage.com",
        display_name="The boy",
        password="securepassword",
        bio="Meow",
        preferences="Suffer",
        location_lat=10.0,
        location_lon=10.0,
    )
    with mock.patch("crud.get_user_by_email", return_value=mock_user):
        with pytest.raises(HTTPException) as excinfo:
            register(mock_user, mock_db_session)

        assert excinfo.value.status_code == 400
        assert excinfo.value.detail == "Email already registered"

@pytest.mark.unit
def test_register_database_error(mock_db_session):
    mock_user = UserCreate(
        email="devnullerror@darkrage.com",
        display_name="The boy",
        password="securepassword",
        bio="Meow",
        preferences="Suffer",
        location_lat=10.0,
        location_lon=10.0,
    )
    with mock.patch("crud.get_user_by_email", side_effect=Exception("Database failure")):
        with pytest.raises(Exception) as excinfo:
            register(mock_user, mock_db_session)

        assert str(excinfo.value) == "Database failure"

@pytest.mark.integration
def test_register_success_fetch(client, test_db):
    mock_user = {
        "email": "devnullfetch@darkrage.com",
        "display_name": "The boy",
        "password": "securepassword",
        "bio": "Meow",
        "preferences": "Eating",
        "location_lat": 10.0,
        "location_lon": 20.0,
    }

    
    response = client.post("/register", json=mock_user)
    assert response.status_code == 200, f"Unexpected response: {response.json()}"
    response_data = response.json()

    assert response_data["email"] == mock_user["email"]
    assert response_data["display_name"] == mock_user["display_name"]
    assert response_data["bio"] == mock_user["bio"]
    assert response_data["preferences"] == mock_user["preferences"]
    assert "id" in response_data
    assert "created_at" in response_data
    assert "updated_at" in response_data
    assert "password_hash" in response_data

@pytest.mark.integration
def test_register_existing_user_fetch(client, test_db):
    mock_user = {
        "email": "devnullfetch@darkrage.com",
        "display_name": "The boy",
        "password": "securepassword",
        "bio": "Meow",
        "preferences": "Eating",
        "location_lat": 10.0,
        "location_lon": 20.0,
    }
    
    test_db.execute(
        text(
            "INSERT INTO users (email, display_name, password_hash) VALUES (:email, :display_name, :password_hash)"
        ),
        {
            "email": mock_user["email"],
            "display_name": mock_user["display_name"],
            "password_hash": "hashedpassword",
        },
    )
    test_db.commit()

    response = client.post("/register", json=mock_user)
    assert response.status_code == 400
    assert response.json()["detail"] == "Email already registered"
