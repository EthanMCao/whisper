from typing import Optional

from sqlmodel import SQLModel, Field


class User(SQLModel, table=True):
    """
    The User table: stores username + hashed_password.
    """
    id: Optional[int] = Field(default=None, primary_key=True)
    username: str = Field(index=True, unique=True)
    hashed_password: str
