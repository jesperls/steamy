import pytest
from unittest import mock
from fastapi import HTTPException
from main import app, update_profile
from schemas import UserUpdate
from fastapi.testclient import TestClient
from db_manager import get_db
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from models import Base

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
def test_update_profile_success(mock_db_session):
    mock_user_update = UserUpdate(
        id=1,
        email="devnull@darkrage.com",
        display_name="Updated Boy",
        bio="Updated Bio",
        preferences="Updated Preferences",
        location_lat=15.0,
        location_lon=25.0,
    )
    mock_db_user = mock.Mock()
    with mock.patch(
        "crud.get_user_by_id", return_value=mock_db_user
    ) as mock_get_user, mock.patch(
        "crud.update_user", return_value=mock_db_user
    ) as mock_update_user:
        result = update_profile(user=mock_user_update, db=mock_db_session)

        assert result == mock_db_user
        mock_get_user.assert_called_once_with(mock_db_session, id=mock_user_update.id)
        mock_update_user.assert_called_once_with(
            db=mock_db_session, db_user=mock_db_user, user=mock_user_update
        )


@pytest.mark.unit
def test_update_profile_user_not_found(mock_db_session):
    mock_user_update = UserUpdate(id=999)
    with mock.patch("crud.get_user_by_id", return_value=None) as mock_get_user:
        with pytest.raises(HTTPException) as excinfo:
            update_profile(user=mock_user_update, db=mock_db_session)

        assert excinfo.value.status_code == 404
        assert excinfo.value.detail == "User not found"
        mock_get_user.assert_called_once_with(mock_db_session, id=mock_user_update.id)


@pytest.mark.unit
def test_update_profile_database_failure(mock_db_session):
    mock_user_update = UserUpdate(id=1)
    with mock.patch(
        "crud.get_user_by_id", side_effect=Exception("Database failure")
    ) as mock_get_user:
        with pytest.raises(Exception) as excinfo:
            update_profile(user=mock_user_update, db=mock_db_session)

        assert str(excinfo.value) == "Database failure"
        mock_get_user.assert_called_once_with(mock_db_session, id=mock_user_update.id)


@pytest.mark.integration
def test_update_profile_success_integration(client, test_db):
    test_user = {
        "id": 1,
        "email": "devnull@darkrage.com",
        "display_name": "The boy",
        "password_hash": "hashedpassword",
        "bio": "Meow",
        "preferences": "Suffer",
        "location_lat": 10.0,
        "location_lon": 20.0,
    }
    test_db.execute(
        text(
            "INSERT INTO users (id, email, display_name, password_hash, bio, preferences, location_lat, location_lon) "
            "VALUES (:id, :email, :display_name, :password_hash, :bio, :preferences, :location_lat, :location_lon)"
        ),
        test_user,
    )
    test_db.commit()

    updated_user = {
        "id": 1,
        "email": "devnullupdated@darkrage.com",
        "display_name": "Updated Boy",
        "bio": "Any breedable females in the area?",
        "preferences": "Yelling",
        "location_lat": 15.0,
        "location_lon": 25.0,
    }
    response = client.put("/updateProfile", json=updated_user)

    assert response.status_code == 200, f"Unexpected response: {response.json()}"
    response_data = response.json()

    assert response_data["email"] == updated_user["email"]
    assert response_data["display_name"] == updated_user["display_name"]
    assert response_data["bio"] == updated_user["bio"]
    assert response_data["preferences"] == updated_user["preferences"]
    assert response_data["location_lat"] == updated_user["location_lat"]
    assert response_data["location_lon"] == updated_user["location_lon"]


@pytest.mark.integration
def test_update_profile_user_not_found_integration(client):
    updated_user = {
        "id": 999,
        "email": "nodevnull@darkrage.com",
        "display_name": "Non-existent Boy",
    }
    response = client.put("/updateProfile", json=updated_user)

    assert response.status_code == 404
    assert response.json()["detail"] == "User not found"
