import pytest
from unittest import mock
from fastapi import HTTPException
from main import app, send_message
from schemas import MessageCreate
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
def test_send_message_success(mock_db_session):
    mock_message = MessageCreate(sender_id=1, receiver_id=2, message_text="Meow")
    with mock.patch("crud.send_message", return_value={"id": 1, "match_id": 1, "message_text": "Meow"}):
        result = send_message(message=mock_message, db=mock_db_session)
        assert result["message"] == "Message sent successfully"
        assert result["data"]["message_text"] == "Meow"

@pytest.mark.unit
def test_send_message_users_not_matched(mock_db_session):
    mock_message = MessageCreate(sender_id=1, receiver_id=2, message_text="Ohana")
    with mock.patch("crud.send_message", return_value={"error": "Users are not mutually matched or sender is not part of the match."}):
        with pytest.raises(HTTPException) as excinfo:
            send_message(message=mock_message, db=mock_db_session)
        assert excinfo.value.status_code == 400
        assert excinfo.value.detail == "Users are not mutually matched or sender is not part of the match."

@pytest.mark.unit
def test_send_message_database_failure(mock_db_session):
    mock_message = MessageCreate(sender_id=1, receiver_id=2, message_text="Grr")
    with mock.patch("crud.send_message", side_effect=Exception("Database failure")):
        with pytest.raises(Exception) as excinfo:
            send_message(message=mock_message, db=mock_db_session)
        assert str(excinfo.value) == "Database failure"


@pytest.mark.integration
def test_send_message_success_integration(client, test_db):
    test_match = {"id": 1, "user_id_1": 1, "user_id_2": 2, "is_matched": True}
    test_db.execute(
        text(
            "INSERT INTO matches (id, user_id_1, user_id_2, is_matched) VALUES (:id, :user_id_1, :user_id_2, :is_matched)"
        ),
        test_match,
    )
    test_db.commit()

    message_data = {"sender_id": 1, "receiver_id": 2, "message_text": "Jag använder bara flip-phones"}
    response = client.post("/sendMessage", json=message_data)

    assert response.status_code == 200
    response_data = response.json()
    assert response_data["message"] == "Message sent successfully"
    assert response_data["data"]["message_text"] == "Jag använder bara flip-phones"

@pytest.mark.integration
def test_send_message_users_not_matched_integration(client, test_db):
    message_data = {"sender_id": 3, "receiver_id": 4, "message_text": "Steamy bra"}
    response = client.post("/sendMessage", json=message_data)

    assert response.status_code == 400
    assert response.json()["detail"] == "Users are not mutually matched or sender is not part of the match."
