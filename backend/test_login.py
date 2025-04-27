import pytest
import time

@pytest.fixture
def registered_client(client):
    # Use a unique username with a timestamp to avoid conflicts
    username = f"bob_{int(time.time())}"
    res = client.post("/signup", json={"username": username, "password": "pass123"})
    assert res.status_code == 201
    return client, username  # Return both the client and the username

def test_login_success(registered_client):
    client, username = registered_client
    res = client.post("/login", json={"username": username, "password": "pass123"})
    assert res.status_code == 200
    assert "access_token" in res.json()
    assert res.json()["token_type"] == "bearer"

def test_login_wrong_password(registered_client):
    client, username = registered_client
    res = client.post("/login", json={"username": username, "password": "wrong"})
    assert res.status_code == 401
    assert res.json()["detail"] == "Invalid credentials"

def test_login_nonexistent_user(client):
    # Using a random username that shouldn't exist
    res = client.post("/login", json={"username": f"nonexistent_{int(time.time())}", "password": "whatever"})
    assert res.status_code == 401
    assert res.json()["detail"] == "Invalid credentials"