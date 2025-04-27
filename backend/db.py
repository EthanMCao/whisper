from sqlmodel import Session, SQLModel, create_engine
from contextlib import contextmanager

# Your existing database setup code
sqlite_file_name = "whisper.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"
engine = create_engine(sqlite_url)

def init_db():
    SQLModel.metadata.create_all(engine)

# Fix this function to properly yield the session
def get_session():
    with Session(engine) as session:
        yield session