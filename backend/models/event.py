"""Event model for MongoDB"""
from datetime import datetime
from mongoengine import Document, StringField, DateTimeField, FloatField, IntField, ReferenceField


class Event(Document):
    """Event model for ticket booking system"""
    meta = {
        'collection': 'events',
        'indexes': ['category', 'date']
    }
    
    title = StringField(required=True, max_length=200)
    description = StringField(required=True)
    category = StringField(required=True, max_length=50)
    location = StringField(required=True, max_length=200)
    date = DateTimeField(required=True)
    price = FloatField(required=True)
    image_url = StringField(required=True, max_length=500)
    available_tickets = IntField(required=True, default=0)
    organizer_name = StringField(required=True, max_length=100)
    organizer_id = ReferenceField('User')  # Link to organizer user
    created_at = DateTimeField(default=datetime.utcnow)
    
    def to_dict(self):
        """Convert to dictionary"""
        return {
            'id': str(self.id),
            'title': self.title,
            'description': self.description,
            'category': self.category,
            'location': self.location,
            'date': self.date.isoformat(),
            'price': self.price,
            'imageUrl': self.image_url,
            'availableTickets': self.available_tickets,
            'organizerName': self.organizer_name,
            'organizerId': str(self.organizer_id.id) if self.organizer_id else None
        }
    
    @property
    def is_upcoming(self):
        """Check if event is upcoming"""
        return self.date > datetime.utcnow()
    
    @property
    def has_tickets_available(self):
        """Check if tickets are available"""
        return self.available_tickets > 0
    
    def __repr__(self):
        return f'<Event {self.title}>'
