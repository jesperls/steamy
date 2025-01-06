import os
from sqlalchemy import create_engine, text, inspect
from sqlalchemy.orm import sessionmaker, scoped_session, Session
from models import Base

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./Database/database.db")

os.makedirs(os.path.dirname(DATABASE_URL.split("///")[1]), exist_ok=True)

engine = create_engine(DATABASE_URL)
SessionLocal = scoped_session(
    sessionmaker(autocommit=False, autoflush=False, bind=engine)
)


def init_db():
    db: Session = SessionLocal()
    try:
        inspector = inspect(engine)
        tables = inspector.get_table_names()
        if not tables:
            Base.metadata.create_all(bind=engine)
            sql_file_path = os.path.join(
                os.path.dirname(__file__), "Database", "test_data.sql"
            )
            load_sql_file(db, sql_file_path)
        else:
            Base.metadata.create_all(bind=engine)
    finally:
        db.close()


def load_sql_file(db: Session, file_path: str):
    with open(file_path, "r") as file:
        sql = file.read()
    statements = sql.strip().split(";")
    for statement in statements:
        if statement.strip():
            db.execute(text(statement))
    db.commit()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
