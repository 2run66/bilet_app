#!/usr/bin/env python3
"""
Add test events and tickets to MongoDB for testing
User: test@example.com
"""

import os
import sys
from datetime import datetime, timedelta
from dotenv import load_dotenv
import certifi

# Load environment variables
load_dotenv()

# Add parent directory to path to import models
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from mongoengine import connect
from models.user import User
from models.event import Event
from models.ticket import Ticket

# Connect to MongoDB
MONGODB_URI = os.getenv('MONGODB_URI', 'mongodb://localhost:27017/bilet_app')
print(f"🔗 Connecting to MongoDB...")
connect(host=MONGODB_URI, tlsCAFile=certifi.where())
print(f"✅ MongoDB connected successfully!")


def clear_test_data():
    """Clear existing test data"""
    print("\n🗑️  Clearing existing test data...")
    Event.objects().delete()
    Ticket.objects().delete()
    print("✅ Test data cleared")


def create_test_user():
    """Create or get test user"""
    print("\n👤 Creating/Getting test user...")
    
    # Try to find existing user
    user = User.objects(email='test@example.com').first()
    
    if not user:
        user = User(
            email='test@example.com',
            name='Test User',
            phone='+1234567890',
            role='user'
        )
        user.set_password('test123')
        user.save()
        print(f"✅ Created new user: {user.email}")
    else:
        print(f"✅ Found existing user: {user.email}")
    
    return user


def create_events():
    """Create sample events"""
    print("\n🎉 Creating sample events...")
    
    now = datetime.now()
    
    events_data = [
        {
            'title': 'Summer Music Festival 2025',
            'description': 'A day full of amazing music performances from top artists. Experience live music, food trucks, and great vibes!',
            'category': 'Music',
            'location': 'Central Park, New York',
            'date': now + timedelta(days=15),
            'price': 49.99,
            'image_url': 'https://picsum.photos/seed/music1/800/450',
            'available_tickets': 450,
            'organizer_name': 'LiveNation Events'
        },
        {
            'title': 'Tech Conference 2025',
            'description': 'Join industry leaders for talks, workshops, and networking. Learn about the latest in AI, cloud computing, and web development.',
            'category': 'Conference',
            'location': 'Convention Center, San Francisco',
            'date': now + timedelta(days=30),
            'price': 199.00,
            'image_url': 'https://picsum.photos/seed/tech1/800/450',
            'available_tickets': 800,
            'organizer_name': 'TechOrg International'
        },
        {
            'title': 'City Marathon 2025',
            'description': 'Annual city marathon open to all fitness levels. Join thousands of runners for this iconic race through the city.',
            'category': 'Sports',
            'location': 'Downtown Starting Point',
            'date': now + timedelta(days=45),
            'price': 35.00,
            'image_url': 'https://picsum.photos/seed/run1/800/450',
            'available_tickets': 1500,
            'organizer_name': 'City Sports Association'
        },
        {
            'title': 'Shakespeare in the Park',
            'description': 'An enchanting evening of classic theatre under the stars. Experience timeless Shakespeare performed by talented actors.',
            'category': 'Theatre',
            'location': 'Open Air Theatre, Central Park',
            'date': now + timedelta(days=10),
            'price': 25.00,
            'image_url': 'https://picsum.photos/seed/theatre1/800/450',
            'available_tickets': 250,
            'organizer_name': 'Park Theatre Company'
        },
        {
            'title': 'Jazz Night at the Blue Note',
            'description': 'Intimate jazz performance featuring legendary musicians. Enjoy smooth jazz and cocktails in a cozy atmosphere.',
            'category': 'Music',
            'location': 'Blue Note Jazz Club',
            'date': now + timedelta(days=7),
            'price': 45.00,
            'image_url': 'https://picsum.photos/seed/jazz1/800/450',
            'available_tickets': 120,
            'organizer_name': 'Blue Note Productions'
        },
        {
            'title': 'Food & Wine Festival',
            'description': 'Taste exquisite dishes from renowned chefs paired with fine wines. A culinary journey you won\'t forget!',
            'category': 'Festival',
            'location': 'Waterfront Plaza',
            'date': now + timedelta(days=20),
            'price': 75.00,
            'image_url': 'https://picsum.photos/seed/food1/800/450',
            'available_tickets': 350,
            'organizer_name': 'Gourmet Events Inc'
        }
    ]
    
    created_events = []
    for event_data in events_data:
        event = Event(**event_data)
        event.save()
        created_events.append(event)
        print(f"  ✓ Created: {event.title} (ID: {event.id})")
    
    print(f"✅ Created {len(created_events)} events")
    return created_events


def create_tickets(user, events):
    """Create sample tickets for the test user"""
    print(f"\n🎫 Creating tickets for {user.email}...")
    
    # Create 3 active tickets for upcoming events
    tickets_to_create = [
        {
            'event': events[3],  # Shakespeare in the Park (10 days away)
            'status': 'active',
            'purchase_date': datetime.now() - timedelta(days=5)
        },
        {
            'event': events[4],  # Jazz Night (7 days away)
            'status': 'active',
            'purchase_date': datetime.now() - timedelta(days=3)
        },
        {
            'event': events[0],  # Summer Music Festival (15 days away)
            'status': 'active',
            'purchase_date': datetime.now() - timedelta(days=1)
        }
    ]
    
    created_tickets = []
    for ticket_data in tickets_to_create:
        event = ticket_data['event']
        
        # Generate QR code data (simple string for testing)
        qr_data = f"TICKET-{user.id}-{event.id}-{datetime.now().timestamp()}"
        
        ticket = Ticket(
            user_id=user,
            event_id=event,
            event_title=event.title,
            event_location=event.location,
            event_date=event.date,
            status=ticket_data['status'],
            purchase_date=ticket_data['purchase_date'],
            price=event.price,
            qr_code=qr_data
        )
        ticket.save()
        created_tickets.append(ticket)
        print(f"  ✓ Created ticket for: {event.title}")
    
    print(f"✅ Created {len(created_tickets)} tickets")
    return created_tickets


def main():
    """Main function"""
    print("=" * 60)
    print("  Adding Test Data to MongoDB")
    print("=" * 60)
    
    try:
        # Clear existing test data
        clear_test_data()
        
        # Create test user
        user = create_test_user()
        
        # Create events
        events = create_events()
        
        # Create tickets
        tickets = create_tickets(user, events)
        
        print("\n" + "=" * 60)
        print("✅ Test data added successfully!")
        print("=" * 60)
        print(f"\n📊 Summary:")
        print(f"  • User: {user.email} (password: test123)")
        print(f"  • Events: {len(events)}")
        print(f"  • Tickets: {len(tickets)}")
        print("\n🎯 You can now test the app with:")
        print(f"  Email: test@example.com")
        print(f"  Password: test123")
        print("\n")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()

