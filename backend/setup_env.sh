#!/bin/bash

# Setup environment file for Bilet App Backend

echo "🔧 Setting up environment configuration..."

cat > .env << 'EOF'
# Flask Configuration
FLASK_ENV=development
PORT=5050

# Security Keys (CHANGE THESE IN PRODUCTION!)
SECRET_KEY=bilet-app-secret-key-change-in-production-2024
JWT_SECRET_KEY=bilet-app-jwt-secret-key-change-in-production-2024

# MongoDB Configuration (MongoDB Atlas)
MONGODB_URI=mongodb+srv://2run66:Y24kXu0xrYBqDTYP@cluster0.deemhas.mongodb.net/bilet_app?retryWrites=true&w=majority&appName=Cluster0
EOF

echo "✅ .env file created successfully!"
echo ""
echo "⚠️  IMPORTANT: Never commit the .env file to git!"
echo "    It's already in .gitignore for your protection."
echo ""
echo "📝 Configuration:"
echo "   - MongoDB Atlas is configured"
echo "   - Database: bilet_app"
echo "   - Port: 5050"
echo ""
echo "🚀 Next steps:"
echo "   1. Install dependencies: pip install -r requirements.txt"
echo "   2. Run the app: python app.py"
echo "   3. Seed sample data: python seed_data.py"

