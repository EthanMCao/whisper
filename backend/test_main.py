from fastapi.testclient import TestClient
from main import app

def test_say_hello():
    client = TestClient(app)
    res = client.get("/hello")
    assert res.status_code == 200
    assert res.json() == {"message": "Hello, Whisper!"}
