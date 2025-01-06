import pytest
from unittest import mock
from fastapi import HTTPException
from main import login, app
from schemas import UserLogin
from fastapi.testclient import TestClient
from db_manager import get_db
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from models import Base
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

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
def test_login_success(mock_db_session):
    mock_credentials = UserLogin(
        email="devnull@darkrage.com", password="securepassword"
    )
    mock_user = mock.Mock(
        email=mock_credentials.email,
        password_hash=pwd_context.hash(mock_credentials.password),
    )

    with mock.patch("crud.get_user_by_email", return_value=mock_user) as mock_get_user:
        result = login(user=mock_credentials, db=mock_db_session)

        assert result == mock_user
        mock_get_user.assert_called_once_with(
            mock_db_session, email=mock_credentials.email
        )


@pytest.mark.unit
def test_login_invalid_credentials(mock_db_session):
    mock_credentials = UserLogin(email="devnull@darkrage.com", password="wrongpassword")

    with mock.patch(
        "crud.authenticate_user", return_value=None
    ) as mock_authenticate_user:
        with pytest.raises(HTTPException) as excinfo:
            login(user=mock_credentials, db=mock_db_session)

        assert excinfo.value.status_code == 400
        assert excinfo.value.detail == "Invalid credentials"
        mock_authenticate_user.assert_called_once_with(
            db=mock_db_session, credentials=mock_credentials
        )


@pytest.mark.unit
def test_login_database_error(mock_db_session):
    mock_credentials = UserLogin(
        email="devnull@darkrage.com", password="securepassword"
    )

    with mock.patch(
        "crud.authenticate_user", side_effect=Exception("Database failure")
    ) as mock_authenticate_user:
        with pytest.raises(Exception) as excinfo:
            login(user=mock_credentials, db=mock_db_session)

        assert str(excinfo.value) == "Database failure"
        mock_authenticate_user.assert_called_once_with(
            db=mock_db_session, credentials=mock_credentials
        )


# INVALID CREDS FIX
@pytest.mark.integration
def test_login_success_fetch(client, test_db):
    test_password = "securepassword"
    hashed_password = pwd_context.hash(test_password)
    test_user = {
        "email": "devnull@darkrage.com",
        "display_name": "Meowserz",
        "password_hash": hashed_password,
    }

    test_db.execute(
        text(
            "INSERT INTO users (email, display_name, password_hash) VALUES (:email, :display_name, :password_hash)"
        ),
        test_user,
    )
    test_db.commit()

    mock_credentials = {"email": test_user["email"], "password": test_password}
    response = client.post("/login", json=mock_credentials)

    assert response.status_code == 200, f"Unexpected response: {response.json()}"
    response_data = response.json()

    assert response_data["email"] == test_user["email"]
    assert "password_hash" in response_data


@pytest.mark.integration
def test_login_invalid_credentials_fetch(client, test_db):
    test_password = "securepassword"
    hashed_password = pwd_context.hash(test_password)
    test_user = {
        "email": "devnull@darkrage.com",
        "display_name": "Meowserz",
        "password_hash": hashed_password,
    }
    test_db.execute(
        text(
            "INSERT INTO users (email, display_name, password_hash) VALUES (:email, :display_name, :password_hash)"
        ),
        test_user,
    )
    test_db.commit()

    mock_credentials = {"email": test_user["email"], "password": "wrongpassword"}
    response = client.post("/login", json=mock_credentials)

    assert response.status_code == 400
    assert response.json()["detail"] == "Invalid credentials"
