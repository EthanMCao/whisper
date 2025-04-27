import pytest
from fastapi.testclient import TestClient
from sqlmodel import SQLModel, Session, create_engine
from sqlmodel.pool import StaticPool

from db import get_session
from main import app

@pytest.fixture
def test_engine():
    """Create a test engine using in-memory SQLite with thread-local connections."""
    return create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool
    )

@pytest.fixture
def reset_db(test_engine):
    """Create all tables for each test."""
    SQLModel.metadata.create_all(test_engine)
    yield
    SQLModel.metadata.drop_all(test_engine)

@pytest.fixture
def client(test_engine, reset_db):
    """Create a test client with a clean database."""
    
    # Override the get_session dependency
    def get_test_session():
        with Session(test_engine) as session:
            yield session
    
    # Use FastAPI's dependency override
    app.dependency_overrides[get_session] = get_test_session
    
    # Return the test client
    with TestClient(app) as c:
        yield c
    
    # Reset the dependency override
    app.dependency_overrides.clear()