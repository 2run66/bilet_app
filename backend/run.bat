@echo off
REM Bilet App Backend Startup Script for Windows

echo Starting Bilet App Backend...

REM Check if virtual environment exists
if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

REM Install dependencies
echo Installing dependencies...
pip install -r requirements.txt

REM Check if .env exists
if not exist ".env" (
    echo .env file not found!
    echo Creating .env from template...
    copy env_example.txt .env
    echo Please update .env with your configuration
)

REM Run the application
echo Starting Flask application...
python app.py

pause

