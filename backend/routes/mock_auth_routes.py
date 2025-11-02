"""Mock authentication routes for testing without database"""
from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, create_refresh_token
from datetime import datetime

mock_auth_bp = Blueprint('mock_auth', __name__, url_prefix='/api/mock/auth')

# In-memory user storage for testing
mock_users = {}


@mock_auth_bp.route('/register', methods=['POST'])
def mock_register():
    """Register a new user (mock)"""
    data = request.get_json()
    
    # Validate required fields
    required_fields = ['email', 'password', 'name']
    if not all(field in data for field in required_fields):
        return jsonify({'error': 'Missing required fields'}), 400
    
    email = data['email']
    
    # Check if user already exists
    if email in mock_users:
        return jsonify({'error': 'Email already registered'}), 400
    
    # Create mock user
    user_id = f"user_{len(mock_users) + 1}"
    mock_users[email] = {
        'id': user_id,
        'email': email,
        'name': data['name'],
        'phone': data.get('phone'),
        'password': data['password'],  # In real app, this would be hashed
        'role': 'user',
        'created_at': datetime.utcnow().isoformat()
    }
    
    # Create tokens
    access_token = create_access_token(identity=user_id)
    refresh_token = create_refresh_token(identity=user_id)
    
    user_data = mock_users[email].copy()
    del user_data['password']  # Don't return password
    
    return jsonify({
        'message': 'User registered successfully',
        'user': user_data,
        'access_token': access_token,
        'refresh_token': refresh_token
    }), 201


@mock_auth_bp.route('/login', methods=['POST'])
def mock_login():
    """Login user (mock)"""
    data = request.get_json()
    
    # Validate required fields
    if not data.get('email') or not data.get('password'):
        return jsonify({'error': 'Email and password are required'}), 400
    
    email = data['email']
    password = data['password']
    
    # Check if user exists
    if email not in mock_users:
        return jsonify({'error': 'Invalid email or password'}), 401
    
    # Check password
    user = mock_users[email]
    if user['password'] != password:
        return jsonify({'error': 'Invalid email or password'}), 401
    
    # Create tokens
    access_token = create_access_token(identity=user['id'])
    refresh_token = create_refresh_token(identity=user['id'])
    
    user_data = user.copy()
    del user_data['password']  # Don't return password
    
    return jsonify({
        'message': 'Login successful',
        'user': user_data,
        'access_token': access_token,
        'refresh_token': refresh_token
    }), 200


@mock_auth_bp.route('/status', methods=['GET'])
def mock_status():
    """Get mock auth status"""
    return jsonify({
        'message': 'Mock authentication is active',
        'total_users': len(mock_users),
        'users': [{'email': u['email'], 'name': u['name']} for u in mock_users.values()]
    }), 200

