# backend/test_db.py

import sqlite3
from db import init_db

def test_user_table_created():
    # Create the tables in the real whisper.db (in backend/)
    init_db()

    # Open the actual whisper.db file
    conn = sqlite3.connect("whisper.db")
    cursor = conn.cursor()

    # List all tables
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = [row[0] for row in cursor.fetchall()]
    conn.close()

    # Assert that we have a 'user' table
    assert "user" in tables
