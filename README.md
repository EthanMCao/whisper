Whisper

A privacy-first iOS chat app with end-to-end encryption.

##Project Structure

.gitignore
README.md
backend/
  └ hello.py
Whisper/
  └ ContentView.swift
WhisperTests/
WhisperUITests/



Getting Started

iOS App
In your repo root, open Whisper.xcodeproj in Xcode.
Select the Whisper scheme and click Run to launch in the Simulator.

Backend Stub
cd backend
python3 -m venv env     # create a virtual environment
env/bin/activate       # on Windows use `env\Scripts\activate`
pip install fastapi uvicorn
uvicorn hello:app --reload

Then visit http://localhost:8000/hello in your browser. You should see:
'''{"message": "Hello, Whisper!"}'''