# schemas.py
from pydantic import BaseModel
from datetime import datetime

class UserCreate(BaseModel):
    username: str
    password: str

class UserRead(BaseModel):
    id: int
    username: str

    class Config:
        orm_mode = True

class LoginRequest(BaseModel):
    username: str
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str

class MessageCreate(BaseModel):
    sender: str
    recipient: str
    content: str

class MessageRead(BaseModel):
    id: int
    sender: str
    recipient: str
    content: str
    timestamp: datetime

    class Config:
        orm_mode = True