# main.py
from fastapi import FastAPI, Depends, HTTPException, status
from typing import List
from sqlmodel import Session, select
from passlib.context import CryptContext
from jose import jwt
import datetime

from db import init_db, get_session
from models import User, Message
from schemas import (
    UserCreate, UserRead,
    LoginRequest, Token,
    MessageCreate, MessageRead,
)

SECRET_KEY = "…"  # your secret
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
app = FastAPI()

@app.on_event("startup")
def on_startup():
    init_db()

@app.get("/hello")
def say_hello():
    return {"message": "Hello, Whisper!"}


@app.post(
    "/signup",
    response_model=UserRead,
    status_code=status.HTTP_201_CREATED,
)
def signup(
    user: UserCreate,
    session: Session = Depends(get_session),
):
    existing = session.exec(
        select(User).where(User.username == user.username)
    ).first()
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username already exists",
        )
    hashed = pwd_context.hash(user.password)
    db_user = User(username=user.username, hashed_password=hashed)
    session.add(db_user)
    session.commit()
    session.refresh(db_user)
    return db_user


def create_access_token(data: dict):
    to_encode = data.copy()
    try:
        # Python 3.11+
        expire = datetime.datetime.now(datetime.UTC) + datetime.timedelta(
            minutes=ACCESS_TOKEN_EXPIRE_MINUTES
        )
    except AttributeError:
        expire = datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(
            minutes=ACCESS_TOKEN_EXPIRE_MINUTES
        )
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


@app.post("/login", response_model=Token)
def login(
    req: LoginRequest,
    session: Session = Depends(get_session),
):
    user = session.exec(
        select(User).where(User.username == req.username)
    ).first()
    if not user or not pwd_context.verify(req.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials",
        )
    token = create_access_token({"sub": user.username})
    return {"access_token": token, "token_type": "bearer"}


@app.post(
    "/messages/send",
    response_model=MessageRead,
    status_code=status.HTTP_201_CREATED,
)
def send_message(
    message: MessageCreate,
    session: Session = Depends(get_session),
):
    # ensure sender exists
    if not session.exec(
        select(User).where(User.username == message.sender)
    ).first():
        raise HTTPException(status_code=404, detail="Sender not found")
    # ensure recipient exists
    if not session.exec(
        select(User).where(User.username == message.recipient)
    ).first():
        raise HTTPException(status_code=404, detail="Recipient not found")

    msg = Message(
        sender=message.sender,
        recipient=message.recipient,
        content=message.content,
    )
    session.add(msg)
    session.commit()
    session.refresh(msg)
    return msg


@app.get(
    "/messages/{username}",
    response_model=List[MessageRead],
)
def get_messages(
    username: str,
    session: Session = Depends(get_session),
):
    # ensure user exists
    if not session.exec(
        select(User).where(User.username == username)
    ).first():
        raise HTTPException(status_code=404, detail="User not found")

    msgs = session.exec(
        select(Message)
        .where(Message.recipient == username)
        .order_by(Message.timestamp)
    ).all()
    return msgs