#!/bin/bash

# Bilet App Backend Startup Script

echo "🚀 Starting Bilet App Backend..."

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install -r requirements.txt

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found!"
    echo "📝 Creating .env from template..."
    cp env_example.txt .env
    echo "✅ Please update .env with your configuration"
fi

# Run the application
echo "🎉 Starting Flask application..."
python app.py

