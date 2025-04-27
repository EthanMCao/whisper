# backend/test_signup.py

import os
from fastapi.testclient import TestClient
from main import app
from db import init_db
import sqlite3

# ── Fresh DB for signup tests ────
if os.path.exists("whisper.db"):
    os.remove("whisper.db")
init_db()

client = TestClient(app)

def test_signup_success():
    res = client.post("/signup", json={"username": "alice", "password": "secret"})
    assert res.status_code == 201

    # Verify in DB
    conn = sqlite3.connect("whisper.db")
    cursor = conn.cursor()
    cursor.execute("SELECT username FROM user WHERE username = ?", ("alice",))
    assert cursor.fetchone()[0] == "alice"
    conn.close()

def test_signup_duplicate():
    res = client.post("/signup", json={"username": "alice", "password": "other"})
    assert res.status_code == 400
    assert res.json()["detail"] == "Username already exists"
