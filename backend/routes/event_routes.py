from flask import Blueprint, request, jsonify
from models import Event
from datetime import datetime
from flask_jwt_extended import jwt_required
from mongoengine.errors import ValidationError, DoesNotExist

event_bp = Blueprint('events', __name__, url_prefix='/api/events')


@event_bp.route('/', methods=['GET'])
def get_events():
    """Get all events with optional filtering"""
    # Query parameters
    category = request.args.get('category')
    search = request.args.get('search')
    upcoming_only = request.args.get('upcoming', 'false').lower() == 'true'
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)
    
    # Build query using MongoEngine Q objects
    queryset = Event.objects
    
    # Filter by category
    if category:
        queryset = queryset.filter(category=category)
    
    # Filter by search term
    if search:
        from mongoengine import Q
        queryset = queryset.filter(
            Q(title__icontains=search) |
            Q(description__icontains=search) |
            Q(location__icontains=search)
        )
    
    # Filter upcoming events
    if upcoming_only:
        queryset = queryset.filter(date__gt=datetime.now())
    
    # Apply ordering
    queryset = queryset.order_by('date')
    total = queryset.count()
    events = queryset.skip((page - 1) * per_page).limit(per_page)
    pages = (total + per_page - 1) // per_page  # Calculate total pages
    
    return jsonify({
        'events': [event.to_dict() for event in events],
        'total': total,
        'pages': pages,
        'current_page': page
    }), 200


@event_bp.route('/<event_id>', methods=['GET'])
def get_event(event_id):
    """Get single event by ID"""
    try:
        event = Event.objects(id=event_id).first()
        
        if not event:
            return jsonify({'error': 'Event not found'}), 404
        
        return jsonify(event.to_dict()), 200
    except Exception:
        return jsonify({'error': 'Invalid event ID'}), 400


@event_bp.route('/', methods=['POST'])
@jwt_required()
def create_event():
    """Create a new event"""
    data = request.get_json()
    
    # Validate required fields
    required_fields = ['title', 'description', 'category', 'location', 'date', 'price', 'imageUrl', 'availableTickets', 'organizerName']
    if not all(field in data for field in required_fields):
        return jsonify({'error': 'Missing required fields'}), 400
    
    try:
        # Parse date
        event_date = datetime.fromisoformat(data['date'].replace('Z', '+00:00'))
        
        # Create event
        event = Event(
            title=data['title'],
            description=data['description'],
            category=data['category'],
            location=data['location'],
            date=event_date,
            price=float(data['price']),
            image_url=data['imageUrl'],
            available_tickets=int(data['availableTickets']),
            organizer_name=data['organizerName']
        )
        event.save()
        
        return jsonify({
            'message': 'Event created successfully',
            'event': event.to_dict()
        }), 201
    
    except ValidationError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@event_bp.route('/<event_id>', methods=['PUT'])
@jwt_required()
def update_event(event_id):
    """Update an event"""
    try:
        event = Event.objects(id=event_id).first()
        
        if not event:
            return jsonify({'error': 'Event not found'}), 404
        
        data = request.get_json()
        
        # Update fields
        if 'title' in data:
            event.title = data['title']
        if 'description' in data:
            event.description = data['description']
        if 'category' in data:
            event.category = data['category']
        if 'location' in data:
            event.location = data['location']
        if 'date' in data:
            event.date = datetime.fromisoformat(data['date'].replace('Z', '+00:00'))
        if 'price' in data:
            event.price = float(data['price'])
        if 'imageUrl' in data:
            event.image_url = data['imageUrl']
        if 'availableTickets' in data:
            event.available_tickets = int(data['availableTickets'])
        if 'organizerName' in data:
            event.organizer_name = data['organizerName']
        
        event.save()
        
        return jsonify({
            'message': 'Event updated successfully',
            'event': event.to_dict()
        }), 200
    
    except ValidationError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@event_bp.route('/<event_id>', methods=['DELETE'])
@jwt_required()
def delete_event(event_id):
    """Delete an event"""
    try:
        event = Event.objects(id=event_id).first()
        
        if not event:
            return jsonify({'error': 'Event not found'}), 404
        
        event.delete()
        
        return jsonify({'message': 'Event deleted successfully'}), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@event_bp.route('/categories', methods=['GET'])
def get_categories():
    """Get all unique event categories"""
    categories = Event.objects.distinct('category')
    
    return jsonify({'categories': categories}), 200
