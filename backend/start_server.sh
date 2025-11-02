#!/bin/bash

# Bilet App Backend Startup Script
# Uses Python 3.12 to avoid SSL issues with MongoDB Atlas

# Activate Python 3.12 conda environment
source ~/miniconda3/bin/activate bilet_py312

# Set environment variables
export FLASK_ENV=development
export PORT=5050

# Start Flask server
cd "$(dirname "$0")"
python app.py

