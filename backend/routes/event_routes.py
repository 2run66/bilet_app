from flask import Blueprint, request, jsonify
from models import Event
from datetime import datetime
from flask_jwt_extended import jwt_required
from mongoengine.errors import ValidationError, DoesNotExist

event_bp = Blueprint('events', __name__, url_prefix='/api/events')


@event_bp.route('/', methods=['GET'])
def get_events():
    """Get all events with optional filtering
    ---
    tags:
      - Events
    parameters:
      - name: category
        in: query
        type: string
        description: Filter by event category
        required: false
      - name: search
        in: query
        type: string
        description: Search in title, description, and location
        required: false
      - name: upcoming
        in: query
        type: boolean
        description: Filter only upcoming events
        default: false
        required: false
      - name: page
        in: query
        type: integer
        description: Page number for pagination
        default: 1
        required: false
      - name: per_page
        in: query
        type: integer
        description: Items per page
        default: 20
        required: false
    responses:
      200:
        description: List of events
        schema:
          type: object
          properties:
            events:
              type: array
              items:
                type: object
            total:
              type: integer
            pages:
              type: integer
            current_page:
              type: integer
    """
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
    """Get single event by ID
    ---
    tags:
      - Events
    parameters:
      - name: event_id
        in: path
        type: string
        required: true
        description: Event ID
    responses:
      200:
        description: Event details
        schema:
          type: object
      400:
        description: Invalid event ID
      404:
        description: Event not found
    """
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
    """Create a new event
    ---
    tags:
      - Events
    security:
      - Bearer: []
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - title
            - description
            - category
            - location
            - date
            - price
            - imageUrl
            - availableTickets
            - organizerName
          properties:
            title:
              type: string
              description: Event title
              example: Summer Music Festival
            description:
              type: string
              description: Event description
              example: A fantastic outdoor music event
            category:
              type: string
              description: Event category
              example: Music
            location:
              type: string
              description: Event location
              example: Istanbul, Turkey
            date:
              type: string
              format: date-time
              description: Event date and time (ISO format)
              example: "2025-07-15T18:00:00Z"
            price:
              type: number
              description: Ticket price
              example: 150.00
            imageUrl:
              type: string
              description: Event image URL
              example: https://example.com/image.jpg
            availableTickets:
              type: integer
              description: Number of available tickets
              example: 500
            organizerName:
              type: string
              description: Event organizer name
              example: Music Events Ltd.
    responses:
      201:
        description: Event created successfully
        schema:
          type: object
          properties:
            message:
              type: string
            event:
              type: object
      400:
        description: Missing required fields or validation error
      401:
        description: Unauthorized
      500:
        description: Internal server error
    """
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
    """Update an event
    ---
    tags:
      - Events
    security:
      - Bearer: []
    parameters:
      - name: event_id
        in: path
        type: string
        required: true
        description: Event ID
      - in: body
        name: body
        required: true
        schema:
          type: object
          properties:
            title:
              type: string
            description:
              type: string
            category:
              type: string
            location:
              type: string
            date:
              type: string
              format: date-time
            price:
              type: number
            imageUrl:
              type: string
            availableTickets:
              type: integer
            organizerName:
              type: string
    responses:
      200:
        description: Event updated successfully
        schema:
          type: object
          properties:
            message:
              type: string
            event:
              type: object
      400:
        description: Validation error
      401:
        description: Unauthorized
      404:
        description: Event not found
      500:
        description: Internal server error
    """
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
    """Delete an event
    ---
    tags:
      - Events
    security:
      - Bearer: []
    parameters:
      - name: event_id
        in: path
        type: string
        required: true
        description: Event ID
    responses:
      200:
        description: Event deleted successfully
        schema:
          type: object
          properties:
            message:
              type: string
      401:
        description: Unauthorized
      404:
        description: Event not found
      500:
        description: Internal server error
    """
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
    """Get all unique event categories
    ---
    tags:
      - Events
    responses:
      200:
        description: List of categories
        schema:
          type: object
          properties:
            categories:
              type: array
              items:
                type: string
    """
    categories = Event.objects.distinct('category')
    
    return jsonify({'categories': categories}), 200
