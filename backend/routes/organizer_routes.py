from flask import Blueprint, request, jsonify
from models import Event, Ticket, User
from datetime import datetime
from flask_jwt_extended import jwt_required, get_jwt_identity
from mongoengine.errors import ValidationError, DoesNotExist
from bson import ObjectId
from functools import wraps

organizer_bp = Blueprint('organizer', __name__, url_prefix='/api/organizer')


def organizer_required(fn):
    """Decorator to check if user is an organizer"""
    @wraps(fn)
    @jwt_required()
    def wrapper(*args, **kwargs):
        current_user_id = get_jwt_identity()
        user = User.objects(id=current_user_id).first()
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        if user.role not in ['organizer', 'admin']:
            return jsonify({'error': 'Organizer access required'}), 403
        
        return fn(*args, **kwargs)
    return wrapper


@organizer_bp.route('/events', methods=['GET'])
@organizer_required
def get_organizer_events():
    """Get all events created by the current organizer"""
    current_user_id = get_jwt_identity()
    user = User.objects(id=current_user_id).first()
    
    # Query parameters
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)
    
    # Get events for this organizer
    queryset = Event.objects(organizer_id=user).order_by('-created_at')
    total = queryset.count()
    events = queryset.skip((page - 1) * per_page).limit(per_page)
    pages = (total + per_page - 1) // per_page
    
    return jsonify({
        'events': [event.to_dict() for event in events],
        'total': total,
        'pages': pages,
        'current_page': page
    }), 200


@organizer_bp.route('/events', methods=['POST'])
@organizer_required
def create_event():
    """Create a new event"""
    current_user_id = get_jwt_identity()
    user = User.objects(id=current_user_id).first()
    
    data = request.get_json()
    
    # Validate required fields
    required_fields = ['title', 'description', 'category', 'location', 'date', 'price', 'availableTickets']
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
            image_url=data.get('imageUrl', 'https://picsum.photos/800/450'),
            available_tickets=int(data['availableTickets']),
            organizer_name=user.name,
            organizer_id=user
        )
        event.save()
        
        return jsonify({
            'message': 'Event created successfully',
            'event': event.to_dict()
        }), 201
    
    except ValueError as e:
        return jsonify({'error': f'Invalid data: {str(e)}'}), 400
    except ValidationError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@organizer_bp.route('/events/<event_id>', methods=['PUT'])
@organizer_required
def update_event(event_id):
    """Update an event"""
    current_user_id = get_jwt_identity()
    user = User.objects(id=current_user_id).first()
    
    try:
        event = Event.objects(id=event_id).first()
        
        if not event:
            return jsonify({'error': 'Event not found'}), 404
        
        # Check if user is the organizer
        if event.organizer_id.id != user.id and user.role != 'admin':
            return jsonify({'error': 'Unauthorized'}), 403
        
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
        
        event.save()
        
        return jsonify({
            'message': 'Event updated successfully',
            'event': event.to_dict()
        }), 200
    
    except DoesNotExist:
        return jsonify({'error': 'Event not found'}), 404
    except ValidationError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@organizer_bp.route('/events/<event_id>', methods=['DELETE'])
@organizer_required
def delete_event(event_id):
    """Delete an event"""
    current_user_id = get_jwt_identity()
    user = User.objects(id=current_user_id).first()
    
    try:
        event = Event.objects(id=event_id).first()
        
        if not event:
            return jsonify({'error': 'Event not found'}), 404
        
        # Check if user is the organizer
        if event.organizer_id.id != user.id and user.role != 'admin':
            return jsonify({'error': 'Unauthorized'}), 403
        
        event.delete()
        
        return jsonify({
            'message': 'Event deleted successfully'
        }), 200
    
    except DoesNotExist:
        return jsonify({'error': 'Event not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@organizer_bp.route('/events/<event_id>/attendees', methods=['GET'])
@organizer_required
def get_event_attendees(event_id):
    """Get all attendees (ticket holders) for an event"""
    current_user_id = get_jwt_identity()
    user = User.objects(id=current_user_id).first()
    
    try:
        event = Event.objects(id=event_id).first()
        
        if not event:
            return jsonify({'error': 'Event not found'}), 404
        
        # Check if user is the organizer
        if event.organizer_id and event.organizer_id.id != user.id and user.role != 'admin':
            return jsonify({'error': 'Unauthorized'}), 403
        
        # Get all tickets for this event
        tickets = Ticket.objects(event_id=event).order_by('-purchase_date')
        
        attendees = []
        for ticket in tickets:
            attendee_data = {
                'ticketId': str(ticket.id),
                'userName': ticket.user_id.name if ticket.user_id else 'Unknown',
                'userEmail': ticket.user_id.email if ticket.user_id else 'Unknown',
                'userPhone': ticket.user_id.phone if ticket.user_id else None,
                'status': ticket.status,
                'purchaseDate': ticket.purchase_date.isoformat() if ticket.purchase_date else None,
                'qrCode': ticket.qr_code
            }
            attendees.append(attendee_data)
        
        return jsonify({
            'event': {
                'id': str(event.id),
                'title': event.title,
                'date': event.date.isoformat()
            },
            'attendees': attendees,
            'total': len(attendees)
        }), 200
    
    except DoesNotExist:
        return jsonify({'error': 'Event not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@organizer_bp.route('/validate-ticket', methods=['POST'])
@organizer_required
def validate_ticket():
    """Validate a ticket by QR code"""
    data = request.get_json()
    
    if not data.get('qrCode'):
        return jsonify({'error': 'QR code is required'}), 400
    
    try:
        # Find ticket by QR code
        ticket = Ticket.objects(qr_code=data['qrCode']).first()
        
        if not ticket:
            return jsonify({
                'valid': False,
                'message': 'Ticket not found'
            }), 404
        
        # Check ticket status
        if ticket.status == 'used':
            return jsonify({
                'valid': False,
                'message': 'Ticket already used',
                'ticket': {
                    'id': str(ticket.id),
                    'eventTitle': ticket.event_title,
                    'userName': ticket.user_id.name if ticket.user_id else 'Unknown',
                    'status': ticket.status
                }
            }), 200
        
        if ticket.status == 'cancelled':
            return jsonify({
                'valid': False,
                'message': 'Ticket cancelled',
                'ticket': {
                    'id': str(ticket.id),
                    'eventTitle': ticket.event_title,
                    'userName': ticket.user_id.name if ticket.user_id else 'Unknown',
                    'status': ticket.status
                }
            }), 200
        
        # Check if event has passed
        if ticket.event_date and ticket.event_date < datetime.now():
            return jsonify({
                'valid': False,
                'message': 'Event has passed',
                'ticket': {
                    'id': str(ticket.id),
                    'eventTitle': ticket.event_title,
                    'userName': ticket.user_id.name if ticket.user_id else 'Unknown',
                    'eventDate': ticket.event_date.isoformat(),
                    'status': ticket.status
                }
            }), 200
        
        # Ticket is valid - mark as used
        ticket.status = 'used'
        ticket.save()
        
        return jsonify({
            'valid': True,
            'message': 'Ticket validated successfully',
            'ticket': {
                'id': str(ticket.id),
                'eventTitle': ticket.event_title,
                'eventLocation': ticket.event_location,
                'eventDate': ticket.event_date.isoformat() if ticket.event_date else None,
                'userName': ticket.user_id.name if ticket.user_id else 'Unknown',
                'userEmail': ticket.user_id.email if ticket.user_id else 'Unknown',
                'price': float(ticket.price) if ticket.price else 0.0,
                'status': ticket.status
            }
        }), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@organizer_bp.route('/stats', methods=['GET'])
@organizer_required
def get_organizer_stats():
    """Get statistics for organizer's events"""
    current_user_id = get_jwt_identity()
    user = User.objects(id=current_user_id).first()
    
    try:
        # Get all events for this organizer
        events = Event.objects(organizer_id=user)
        
        total_events = events.count()
        upcoming_events = events.filter(date__gt=datetime.now()).count()
        
        # Get all tickets for organizer's events
        event_ids = [event for event in events]
        tickets = Ticket.objects(event_id__in=event_ids)
        
        total_tickets_sold = tickets.count()
        total_revenue = sum([float(ticket.price) if ticket.price else 0.0 for ticket in tickets])
        
        return jsonify({
            'totalEvents': total_events,
            'upcomingEvents': upcoming_events,
            'totalTicketsSold': total_tickets_sold,
            'totalRevenue': total_revenue
        }), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

