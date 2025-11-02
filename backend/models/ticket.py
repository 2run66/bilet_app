"""Ticket model for MongoDB"""
from datetime import datetime
from mongoengine import Document, StringField, DateTimeField, FloatField, ReferenceField
from .user import User
from .event import Event


class Ticket(Document):
    """Ticket model for event bookings"""
    meta = {
        'collection': 'tickets',
        'indexes': ['event_id', 'user_id', 'event_date', 'status']
    }
    
    event_id = ReferenceField(Event, required=True)
    user_id = ReferenceField(User, required=True)
    
    # Denormalized event data for quick access
    event_title = StringField(required=True, max_length=200)
    event_location = StringField(required=True, max_length=200)
    event_date = DateTimeField(required=True)
    
    status = StringField(required=True, default='active', max_length=20, choices=['active', 'used', 'expired', 'pending'])
    purchase_date = DateTimeField(default=datetime.utcnow)
    price = FloatField(required=True)
    qr_code = StringField(required=True, max_length=10000)  # Increased for base64 image
    seat_number = StringField(max_length=20)
    
    def to_dict(self):
        """Convert to dictionary"""
        return {
            'id': str(self.id),
            'eventId': str(self.event_id.id) if self.event_id else None,
            'eventTitle': self.event_title,
            'eventLocation': self.event_location,
            'eventDate': self.event_date.isoformat(),
            'userId': str(self.user_id.id) if self.user_id else None,
            'status': f'TicketStatus.{self.status}',
            'purchaseDate': self.purchase_date.isoformat(),
            'price': self.price,
            'qrCode': self.qr_code,
            'seatNumber': self.seat_number
        }
    
    @property
    def is_upcoming(self):
        """Check if ticket is for an upcoming event"""
        return self.event_date > datetime.utcnow() and self.status == 'active'
    
    @property
    def is_past(self):
        """Check if ticket is for a past event"""
        return self.event_date < datetime.utcnow() or self.status == 'used'
    
    @property
    def is_expired(self):
        """Check if ticket is expired"""
        return self.status == 'expired'
    
    def __repr__(self):
        return f'<Ticket {self.id} - {self.event_title}>'
