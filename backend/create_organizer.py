#!/usr/bin/env python3
"""Create an organizer user for testing"""
import os
import certifi
from dotenv import load_dotenv
from mongoengine import connect
from models.user import User

# Load environment variables
load_dotenv()

def connect_db():
    """Connect to MongoDB"""
    uri = os.getenv('MONGODB_URI')
    print(f"🔗 Connecting to MongoDB...")
    connect(host=uri, tlsCAFile=certifi.where())
    print(f"✅ Connected to MongoDB")

def create_organizer_user():
    """Create organizer test user"""
    print("\n👤 Creating organizer user...")
    
    # Check if organizer already exists
    existing = User.objects(email='organizer@example.com').first()
    if existing:
        print(f"⚠️  Organizer user already exists. Updating role...")
        existing.role = 'organizer'
        existing.save()
        print(f"✅ Updated existing user to organizer role")
        return existing
    
    # Create new organizer user
    user = User(
        email='organizer@example.com',
        name='Event Organizer',
        phone='+1 234 567 8901',
        role='organizer'
    )
    user.set_password('organizer123')
    user.save()
    
    print(f"✅ Created organizer user:")
    print(f"   Email: organizer@example.com")
    print(f"   Password: organizer123")
    print(f"   Role: {user.role}")
    
    return user

def main():
    """Main function"""
    try:
        connect_db()
        create_organizer_user()
        
        print("\n" + "="*60)
        print("🎉 Organizer user ready!")
        print("="*60)
        print("\nLogin credentials:")
        print("  Email: organizer@example.com")
        print("  Password: organizer123")
        print("\n" + "="*60)
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()

if __name__ == '__main__':
    main()

