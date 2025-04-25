Whisper

A privacy-first iOS chat app with end-to-end encryption.

Project Structure

.
├── .gitignore
├── README.md
├── backend/
│   └── hello.py
├── Whisper/
│   └── ContentView.swift
├── WhisperTests/
└── WhisperUITests/

Getting Started

iOS App

Open Whisper.xcodeproj in Xcode.

Select the Whisper scheme and hit ▶️ Run on the Simulator.

Backend Stub

cd backend
git pull  # ensure you have the latest code
python3 -m venv env
source env/bin/activate
pip install fastapi uvicorn
uvicorn hello:app --reload

Open http://localhost:8000/hello in your browser to see {"message": "Hello, Whisper!"}.
