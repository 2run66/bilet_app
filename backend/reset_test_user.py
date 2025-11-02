#!/usr/bin/env python3
"""Reset test user password and create organizer if needed"""
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

def reset_test_user():
    """Reset test user password"""
    print("\n👤 Resetting test user...")
    
    user = User.objects(email='test@example.com').first()
    if user:
        user.set_password('test123')
        user.role = 'user'  # Ensure it's a regular user
        user.save()
        print(f"✅ Reset test user:")
        print(f"   Email: test@example.com")
        print(f"   Password: test123")
        print(f"   Role: {user.role}")
    else:
        print("⚠️  Test user not found, creating new one...")
        user = User(
            email='test@example.com',
            name='Test User',
            phone='+1 234 567 8900',
            role='user'
        )
        user.set_password('test123')
        user.save()
        print(f"✅ Created test user:")
        print(f"   Email: test@example.com")
        print(f"   Password: test123")
        print(f"   Role: {user.role}")
    
    return user

def ensure_organizer():
    """Ensure organizer user exists"""
    print("\n👤 Checking organizer user...")
    
    organizer = User.objects(email='organizer@example.com').first()
    if organizer:
        organizer.set_password('organizer123')
        organizer.role = 'organizer'
        organizer.save()
        print(f"✅ Organizer user exists:")
        print(f"   Email: organizer@example.com")
        print(f"   Password: organizer123")
        print(f"   Role: {organizer.role}")
    else:
        print("⚠️  Organizer not found, creating new one...")
        organizer = User(
            email='organizer@example.com',
            name='Event Organizer',
            phone='+1 234 567 8901',
            role='organizer'
        )
        organizer.set_password('organizer123')
        organizer.save()
        print(f"✅ Created organizer user:")
        print(f"   Email: organizer@example.com")
        print(f"   Password: organizer123")
        print(f"   Role: {organizer.role}")
    
    return organizer

def main():
    """Main function"""
    try:
        connect_db()
        reset_test_user()
        ensure_organizer()
        
        print("\n" + "="*60)
        print("🎉 All users ready!")
        print("="*60)
        print("\n📝 Test Accounts:")
        print("\n1. Regular User:")
        print("   Email: test@example.com")
        print("   Password: test123")
        print("   Access: Browse events, buy tickets")
        print("\n2. Organizer:")
        print("   Email: organizer@example.com")
        print("   Password: organizer123")
        print("   Access: Create events, scan tickets, view attendees")
        print("\n" + "="*60)
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()

if __name__ == '__main__':
    main()

