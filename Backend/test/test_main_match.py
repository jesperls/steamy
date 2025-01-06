import pytest
from unittest import mock
from fastapi import HTTPException
from main import app, match_users
from schemas import MatchAction
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
def test_match_users_success(mock_db_session):
    mock_action = MatchAction(matcher_id=1, matched_id=2)
    mock_match = mock.Mock(id=1, is_matched=False)
    with mock.patch("crud.create_or_update_match", return_value=mock_match):
        result = match_users(action=mock_action, db=mock_db_session)
        assert result["message"] == "Match request sent."


@pytest.mark.unit
def test_match_users_already_initiated(mock_db_session):
    mock_action = MatchAction(matcher_id=1, matched_id=2)
    with mock.patch(
        "crud.create_or_update_match",
        return_value={"error": "Match already initiated."},
    ):
        with pytest.raises(HTTPException) as excinfo:
            match_users(action=mock_action, db=mock_db_session)
        assert excinfo.value.status_code == 400
        assert excinfo.value.detail == "Match already initiated."


@pytest.mark.unit
def test_match_users_database_failure(mock_db_session):
    mock_action = MatchAction(matcher_id=1, matched_id=2)
    with mock.patch(
        "crud.create_or_update_match", side_effect=Exception("Database failure")
    ):
        with pytest.raises(Exception) as excinfo:
            match_users(action=mock_action, db=mock_db_session)
        assert str(excinfo.value) == "Database failure"


@pytest.mark.integration
def test_match_users_create_new_match_integration(client, test_db):
    action_data = {"matcher_id": 1, "matched_id": 2}
    response = client.post("/match", json=action_data)

    assert response.status_code == 200
    response_data = response.json()
    assert response_data["message"] == "Match request sent."


# Assertion error
@pytest.mark.integration
def test_match_users_mutual_match_integration(client, test_db):
    test_match = {"id": 1, "user_id_1": 2, "user_id_2": 1, "is_matched": False}
    test_db.execute(
        text(
            "INSERT INTO matches (id, user_id_1, user_id_2, is_matched) VALUES (:id, :user_id_1, :user_id_2, :is_matched)"
        ),
        test_match,
    )
    test_db.commit()

    action_data = {"matcher_id": 1, "matched_id": 2}
    response = client.post("/match", json=action_data)

    assert response.status_code == 200
    response_data = response.json()
    assert response_data["message"] == "It's a mutual match!"


# Assertion error
@pytest.mark.integration
def test_match_users_already_initiated_integration(client, test_db):
    test_match = {"id": 2, "user_id_1": 3, "user_id_2": 4, "is_matched": False}
    test_db.execute(
        text(
            "INSERT INTO matches (id, user_id_1, user_id_2, is_matched) VALUES (:id, :user_id_1, :user_id_2, :is_matched)"
        ),
        test_match,
    )
    test_db.commit()

    action_data = {"matcher_id": 3, "matched_id": 4}
    response = client.post("/match", json=action_data)

    assert response.status_code == 400
    assert response.json()["detail"] == "Match already initiated."
