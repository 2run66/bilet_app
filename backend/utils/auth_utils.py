from functools import wraps
from flask import jsonify
from flask_jwt_extended import verify_jwt_in_request, get_jwt_identity
from models import User


def jwt_required_custom(fn):
    """Custom JWT required decorator with user loading"""
    @wraps(fn)
    def wrapper(*args, **kwargs):
        verify_jwt_in_request()
        current_user_id = get_jwt_identity()
        user = User.objects(id=current_user_id).first()
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        return fn(*args, current_user=user, **kwargs)
    
    return wrapper
