from flask import Blueprint, request, jsonify
from models import Ticket, Event, User
from datetime import datetime
from flask_jwt_extended import jwt_required, get_jwt_identity
from utils.qr_generator import generate_qr_code
from mongoengine.errors import ValidationError, DoesNotExist
from bson import ObjectId
import json

ticket_bp = Blueprint('tickets', __name__, url_prefix='/api/tickets')


@ticket_bp.route('/', methods=['GET'])
@jwt_required()
def get_user_tickets():
    """Get all tickets for current user"""
    current_user_id = get_jwt_identity()
    
    # Query parameters
    status = request.args.get('status')
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)
    
    # Build query - convert user_id string to ObjectId
    query = {'user_id': ObjectId(current_user_id)}
    
    # Filter by status
    if status:
        query['status'] = status
    
    # Query with pagination
    queryset = Ticket.objects(__raw__=query).order_by('-event_date')
    total = queryset.count()
    tickets = queryset.skip((page - 1) * per_page).limit(per_page)
    pages = (total + per_page - 1) // per_page  # Calculate total pages
    
    return jsonify({
        'tickets': [ticket.to_dict() for ticket in tickets],
        'total': total,
        'pages': pages,
        'current_page': page
    }), 200


@ticket_bp.route('/<ticket_id>', methods=['GET'])
@jwt_required()
def get_ticket(ticket_id):
    """Get single ticket by ID"""
    current_user_id = get_jwt_identity()
    
    try:
        ticket = Ticket.objects(id=ticket_id).first()
        
        if not ticket:
            return jsonify({'error': 'Ticket not found'}), 404
        
        # Check if ticket belongs to user
        if str(ticket.user_id.id) != current_user_id:
            return jsonify({'error': 'Unauthorized'}), 403
        
        return jsonify(ticket.to_dict()), 200
    except Exception:
        return jsonify({'error': 'Invalid ticket ID'}), 400


@ticket_bp.route('/purchase', methods=['POST'])
@jwt_required()
def purchase_ticket():
    """Purchase a ticket for an event"""
    current_user_id = get_jwt_identity()
    data = request.get_json()
    
    # Validate required fields
    if not data.get('eventId'):
        return jsonify({'error': 'Event ID is required'}), 400
    
    try:
        # Get event
        event = Event.objects(id=data['eventId']).first()
        if not event:
            return jsonify({'error': 'Event not found'}), 404
        
        # Check if tickets available
        if event.available_tickets <= 0:
            return jsonify({'error': 'No tickets available'}), 400
        
        # Check if event is in the future
        if event.date < datetime.utcnow():
            return jsonify({'error': 'Cannot purchase tickets for past events'}), 400
        
        # Get user
        user = User.objects(id=current_user_id).first()
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Generate QR code data
        ticket_data = {
            'eventId': str(event.id),
            'userId': current_user_id,
            'eventTitle': event.title,
            'eventDate': event.date.isoformat()
        }
        qr_code = generate_qr_code(json.dumps(ticket_data))
        
        # Create ticket
        ticket = Ticket(
            event_id=event,
            user_id=user,
            event_title=event.title,
            event_location=event.location,
            event_date=event.date,
            status='pending',
            price=event.price,
            seat_number=data.get('seatNumber'),
            qr_code=qr_code
        )
        ticket.save()
        
        # Decrease available tickets
        event.available_tickets -= 1
        event.save()
        
        return jsonify({
            'message': 'Ticket purchased successfully',
            'ticket': ticket.to_dict()
        }), 201
    
    except ValidationError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@ticket_bp.route('/<ticket_id>/status', methods=['PATCH'])
@jwt_required()
def update_ticket_status(ticket_id):
    """Update ticket status"""
    current_user_id = get_jwt_identity()
    
    try:
        ticket = Ticket.objects(id=ticket_id).first()
        
        if not ticket:
            return jsonify({'error': 'Ticket not found'}), 404
        
        # Check if ticket belongs to user
        if str(ticket.user_id.id) != current_user_id:
            return jsonify({'error': 'Unauthorized'}), 403
        
        data = request.get_json()
        
        if not data.get('status'):
            return jsonify({'error': 'Status is required'}), 400
        
        # Validate status
        valid_statuses = ['active', 'used', 'expired', 'pending']
        if data['status'] not in valid_statuses:
            return jsonify({'error': 'Invalid status'}), 400
        
        ticket.status = data['status']
        ticket.save()
        
        return jsonify({
            'message': 'Ticket status updated successfully',
            'ticket': ticket.to_dict()
        }), 200
    
    except ValidationError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@ticket_bp.route('/<ticket_id>/activate', methods=['POST'])
@jwt_required()
def activate_ticket(ticket_id):
    """Activate a pending ticket (after payment confirmation)"""
    current_user_id = get_jwt_identity()
    
    try:
        ticket = Ticket.objects(id=ticket_id).first()
        
        if not ticket:
            return jsonify({'error': 'Ticket not found'}), 404
        
        if str(ticket.user_id.id) != current_user_id:
            return jsonify({'error': 'Unauthorized'}), 403
        
        if ticket.status != 'pending':
            return jsonify({'error': 'Ticket is not pending'}), 400
        
        ticket.status = 'active'
        ticket.save()
        
        return jsonify({
            'message': 'Ticket activated successfully',
            'ticket': ticket.to_dict()
        }), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@ticket_bp.route('/<ticket_id>/use', methods=['POST'])
@jwt_required()
def use_ticket(ticket_id):
    """Mark ticket as used (for event organizers)"""
    try:
        ticket = Ticket.objects(id=ticket_id).first()
        
        if not ticket:
            return jsonify({'error': 'Ticket not found'}), 404
        
        if ticket.status != 'active':
            return jsonify({'error': 'Ticket is not active'}), 400
        
        ticket.status = 'used'
        ticket.save()
        
        return jsonify({
            'message': 'Ticket marked as used',
            'ticket': ticket.to_dict()
        }), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@ticket_bp.route('/<ticket_id>', methods=['DELETE'])
@jwt_required()
def delete_ticket(ticket_id):
    """Delete/cancel a ticket"""
    current_user_id = get_jwt_identity()
    
    try:
        ticket = Ticket.objects(id=ticket_id).first()
        
        if not ticket:
            return jsonify({'error': 'Ticket not found'}), 404
        
        if str(ticket.user_id.id) != current_user_id:
            return jsonify({'error': 'Unauthorized'}), 403
        
        # Only allow cancellation for pending or active tickets
        if ticket.status in ['used']:
            return jsonify({'error': 'Cannot cancel used ticket'}), 400
        
        # Return ticket to available pool if not used
        event = Event.objects(id=ticket.event_id.id).first()
        if event:
            event.available_tickets += 1
            event.save()
        
        ticket.delete()
        
        return jsonify({'message': 'Ticket cancelled successfully'}), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500
