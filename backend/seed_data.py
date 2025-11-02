"""
Seed database with sample data for testing
Run with: python seed_data.py
"""
from app import create_app
from models import User, Event, Ticket
from datetime import datetime, timedelta
import random

# Sample data
CATEGORIES = ['Music', 'Sports', 'Theater', 'Comedy', 'Conference', 'Festival']

EVENTS_DATA = [
    {
        'title': 'Summer Music Festival 2024',
        'description': 'Join us for the biggest music festival of the year featuring top artists from around the world.',
        'category': 'Music',
        'location': 'Central Park, New York',
        'price': 99.99,
        'image_url': 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3',
        'available_tickets': 5000,
        'organizer_name': 'Live Nation'
    },
    {
        'title': 'Tech Conference 2024',
        'description': 'Learn about the latest trends in technology and network with industry leaders.',
        'category': 'Conference',
        'location': 'Convention Center, San Francisco',
        'price': 299.00,
        'image_url': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87',
        'available_tickets': 500,
        'organizer_name': 'Tech Events Inc'
    },
    {
        'title': 'NBA Finals Game 7',
        'description': 'Witness history in the making as the championship comes down to the final game.',
        'category': 'Sports',
        'location': 'Madison Square Garden, NY',
        'price': 499.99,
        'image_url': 'https://images.unsplash.com/photo-1546519638-68e109498ffc',
        'available_tickets': 200,
        'organizer_name': 'NBA'
    },
    {
        'title': 'Shakespeare in the Park',
        'description': 'A Midsummer Night\'s Dream performed under the stars in Central Park.',
        'category': 'Theater',
        'location': 'Delacorte Theater, NY',
        'price': 0.00,
        'image_url': 'https://images.unsplash.com/photo-1503095396549-807759245b35',
        'available_tickets': 1800,
        'organizer_name': 'Public Theater'
    },
    {
        'title': 'Comedy Night with Dave Chappelle',
        'description': 'An evening of stand-up comedy with one of the greatest comedians of our time.',
        'category': 'Comedy',
        'location': 'Comedy Club, Los Angeles',
        'price': 75.00,
        'image_url': 'https://images.unsplash.com/photo-1585699324551-f6c309eedeca',
        'available_tickets': 300,
        'organizer_name': 'Laugh Factory'
    },
    {
        'title': 'Food & Wine Festival',
        'description': 'Taste dishes from award-winning chefs and sample wines from around the world.',
        'category': 'Festival',
        'location': 'Waterfront Park, Chicago',
        'price': 125.00,
        'image_url': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1',
        'available_tickets': 2000,
        'organizer_name': 'Culinary Events'
    },
    {
        'title': 'Rock Concert - The Rolling Stones',
        'description': 'The legendary rock band performs their greatest hits on their farewell tour.',
        'category': 'Music',
        'location': 'Stadium, London',
        'price': 150.00,
        'image_url': 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4',
        'available_tickets': 80000,
        'organizer_name': 'AEG Presents'
    },
    {
        'title': 'Art Exhibition: Modern Masters',
        'description': 'An exclusive showing of contemporary art from leading artists worldwide.',
        'category': 'Conference',
        'location': 'Museum of Modern Art, NY',
        'price': 35.00,
        'image_url': 'https://images.unsplash.com/photo-1561214115-f2f134cc4912',
        'available_tickets': 150,
        'organizer_name': 'MoMA'
    }
]


def seed_database():
    """Seed the database with sample data"""
    app = create_app('development')
    
    with app.app_context():
        print("🌱 Seeding database...")
        
        # Clear existing data
        print("  Clearing existing data...")
        User.objects.delete()
        Event.objects.delete()
        Ticket.objects.delete()
        
        # Create sample users
        print("  Creating users...")
        users = []
        for i in range(5):
            user = User(
                email=f'user{i+1}@example.com',
                name=f'Test User {i+1}',
                phone=f'+123456789{i}'
            )
            user.set_password('password123')
            user.save()
            users.append(user)
        
        print(f"  ✓ Created {len(users)} users")
        
        # Create events
        print("  Creating events...")
        events = []
        for event_data in EVENTS_DATA:
            # Random date in the next 3 months
            days_ahead = random.randint(1, 90)
            event_date = datetime.utcnow() + timedelta(days=days_ahead, hours=random.randint(10, 20))
            
            event = Event(
                title=event_data['title'],
                description=event_data['description'],
                category=event_data['category'],
                location=event_data['location'],
                date=event_date,
                price=event_data['price'],
                image_url=event_data['image_url'],
                available_tickets=event_data['available_tickets'],
                organizer_name=event_data['organizer_name']
            )
            event.save()
            events.append(event)
        
        print(f"  ✓ Created {len(events)} events")
        
        # Create some tickets for users
        print("  Creating tickets...")
        tickets_created = 0
        for user in users[:3]:  # First 3 users get tickets
            # Each user gets 2-4 tickets
            num_tickets = random.randint(2, 4)
            user_events = random.sample(events, num_tickets)
            
            for event in user_events:
                status = random.choice(['active', 'pending'])
                ticket = Ticket(
                    event_id=event,
                    user_id=user,
                    event_title=event.title,
                    event_location=event.location,
                    event_date=event.date,
                    status=status,
                    price=event.price,
                    qr_code=f'QR_CODE_{tickets_created}',
                    seat_number=f'{random.choice(["A", "B", "C"])}{random.randint(1, 50)}'
                )
                ticket.save()
                tickets_created += 1
        
        print(f"  ✓ Created {tickets_created} tickets")
        
        print("\n✅ Database seeded successfully!")
        print("\n📝 Sample credentials:")
        print("   Email: user1@example.com")
        print("   Password: password123")
        print("\n   (user2@example.com through user5@example.com also available)")


if __name__ == '__main__':
    seed_database()
