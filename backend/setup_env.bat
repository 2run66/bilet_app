@echo off
REM Setup environment file for Bilet App Backend (Windows)

echo Setting up environment configuration...

(
echo # Flask Configuration
echo FLASK_ENV=development
echo PORT=5050
echo.
echo # Security Keys ^(CHANGE THESE IN PRODUCTION!^)
echo SECRET_KEY=bilet-app-secret-key-change-in-production-2024
echo JWT_SECRET_KEY=bilet-app-jwt-secret-key-change-in-production-2024
echo.
echo # MongoDB Configuration ^(MongoDB Atlas^)
echo MONGODB_URI=mongodb+srv://2run66:Y24kXu0xrYBqDTYP@cluster0.deemhas.mongodb.net/bilet_app?retryWrites=true^&w=majority^&appName=Cluster0
) > .env

echo.
echo .env file created successfully!
echo.
echo IMPORTANT: Never commit the .env file to git!
echo     It's already in .gitignore for your protection.
echo.
echo Configuration:
echo    - MongoDB Atlas is configured
echo    - Database: bilet_app
echo    - Port: 5050
echo.
echo Next steps:
echo    1. Install dependencies: pip install -r requirements.txt
echo    2. Run the app: python app.py
echo    3. Seed sample data: python seed_data.py
echo.
pause

