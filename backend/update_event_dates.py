"""Script to update event dates to future dates"""
from datetime import datetime, timedelta
from mongoengine import connect
import certifi
import os
from dotenv import load_dotenv

load_dotenv()

# Connect to MongoDB
mongodb_uri = os.getenv('MONGODB_URI', 'mongodb://localhost:27017/bilet_app')
print(f"🔗 Connecting to MongoDB...")
connect(host=mongodb_uri, tlsCAFile=certifi.where())
print(f"✅ Connected!")

# Import Event model after connection
from models.event import Event

# Get all events
events = Event.objects()
print(f"\n📋 Found {events.count()} events")

now = datetime.utcnow()

for i, event in enumerate(events):
    # Set event date to future (10 + i*5 days from now)
    new_date = now + timedelta(days=10 + i*5)
    old_date = event.date
    
    # Update the event date
    event.date = new_date
    event.save()
    
    print(f"✅ Updated '{event.title}':")
    print(f"   Old date: {old_date}")
    print(f"   New date: {new_date}")

print(f"\n🎉 Done! Updated all {events.count()} events to future dates.")
