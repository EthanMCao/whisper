from fastapi import FastAPI, WebSocket

app = FastAPI()

@app.get("/hello")
async def say_hello():
    return {"message": "Hello, Whisper!"}

@app.websocket("/ws/ping")
async def ws_ping(ws: WebSocket):
    await ws.accept()
    await ws.send_text("pong")
    await ws.close()
