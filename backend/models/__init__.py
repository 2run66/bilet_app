"""Models package - MongoDB models for Bilet App"""
from mongoengine import connect
import os
import certifi


class MongoEngineWrapper:
    """Wrapper to initialize MongoEngine with Flask"""
    
    def __init__(self, app=None):
        if app is not None:
            self.init_app(app)
    
    def init_app(self, app):
        """Initialize MongoEngine with Flask app"""
        mongodb_settings = app.config.get('MONGODB_SETTINGS', {})
        uri = mongodb_settings.get('MONGODB_URI', os.getenv('MONGODB_URI', 'mongodb://localhost:27017/bilet_app'))
        
        # Remove MONGODB_URI from mongodb_settings if exists to avoid duplicate
        settings = {k: v for k, v in mongodb_settings.items() if k != 'MONGODB_URI'}
        
        # Use certifi CA bundle for SSL verification
        settings['tlsCAFile'] = certifi.where()
        
        # Connect to MongoDB
        print(f"🔗 Connecting to MongoDB Atlas (with certifi)...")
        connect(host=uri, **settings)
        print(f"✅ MongoDB connected successfully! (Python 3.12)")


# Initialize wrapper
db = MongoEngineWrapper()

# Import models after db is created to avoid circular imports
from .user import User
from .event import Event
from .ticket import Ticket

__all__ = ['db', 'User', 'Event', 'Ticket']
