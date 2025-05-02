# models.py
from typing import Optional
from datetime import datetime
from sqlmodel import SQLModel, Field


class User(SQLModel, table=True):
    """
    The User table: stores username + hashed_password.
    """
    id: Optional[int] = Field(default=None, primary_key=True)
    username: str = Field(index=True, unique=True)
    hashed_password: str


class Message(SQLModel, table=True):
    """
    The Message table: each row is one chat message.
    """
    id: Optional[int] = Field(default=None, primary_key=True)
    sender: str = Field(
        foreign_key="user.username",
        index=True,
    )
    recipient: str = Field(
        foreign_key="user.username",
        index=True,
    )
    content: str
    timestamp: datetime = Field(default_factory=datetime.utcnow)