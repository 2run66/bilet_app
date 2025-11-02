"""User model for MongoDB"""
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from mongoengine import Document, StringField, DateTimeField


class User(Document):
    """User model for authentication and profile management"""
    meta = {
        'collection': 'users',
        'indexes': ['email']
    }
    
    email = StringField(required=True, unique=True, max_length=120)
    password_hash = StringField(required=True, max_length=255)
    name = StringField(required=True, max_length=100)
    phone = StringField(max_length=20)
    role = StringField(required=True, default='user', choices=['user', 'organizer', 'admin'])
    created_at = DateTimeField(default=datetime.utcnow)
    
    def set_password(self, password):
        """Hash and set password"""
        self.password_hash = generate_password_hash(password)
    
    def check_password(self, password):
        """Check if password matches hash"""
        return check_password_hash(self.password_hash, password)
    
    def to_dict(self):
        """Convert to dictionary"""
        return {
            'id': str(self.id),
            'email': self.email,
            'name': self.name,
            'phone': self.phone,
            'role': self.role,
            'createdAt': self.created_at.isoformat() if self.created_at else None
        }
    
    def __repr__(self):
        return f'<User {self.email}>'
