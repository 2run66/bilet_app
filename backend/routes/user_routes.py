from flask import Blueprint, request, jsonify
from models import User
from flask_jwt_extended import jwt_required, get_jwt_identity
from mongoengine.errors import NotUniqueError, ValidationError

user_bp = Blueprint('users', __name__, url_prefix='/api/users')


@user_bp.route('/profile', methods=['GET'])
@jwt_required()
def get_profile():
    """Get current user profile
    ---
    tags:
      - Users
    security:
      - Bearer: []
    responses:
      200:
        description: User profile
        schema:
          type: object
          properties:
            id:
              type: string
            email:
              type: string
            name:
              type: string
            phone:
              type: string
            role:
              type: string
      401:
        description: Unauthorized
      404:
        description: User not found
    """
    current_user_id = get_jwt_identity()
    user = User.objects(id=current_user_id).first()
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    return jsonify(user.to_dict()), 200


@user_bp.route('/profile', methods=['PUT'])
@jwt_required()
def update_profile():
    """Update current user profile
    ---
    tags:
      - Users
    security:
      - Bearer: []
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          properties:
            name:
              type: string
              description: User's name
              example: John Doe
            phone:
              type: string
              description: User's phone number
              example: "+905551234567"
            email:
              type: string
              description: User's email
              example: john@example.com
    responses:
      200:
        description: Profile updated successfully
        schema:
          type: object
          properties:
            message:
              type: string
            user:
              type: object
      400:
        description: Validation error
      401:
        description: Unauthorized
      404:
        description: User not found
      409:
        description: Email already in use
      500:
        description: Internal server error
    """
    current_user_id = get_jwt_identity()
    user = User.objects(id=current_user_id).first()
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    data = request.get_json()
    
    try:
        # Update allowed fields
        if 'name' in data:
            user.name = data['name']
        if 'phone' in data:
            user.phone = data['phone']
        if 'email' in data:
            # Check if email is already taken by another user
            existing_user = User.objects(email=data['email']).first()
            if existing_user and str(existing_user.id) != current_user_id:
                return jsonify({'error': 'Email already in use'}), 409
            user.email = data['email']
        
        user.save()
        
        return jsonify({
            'message': 'Profile updated successfully',
            'user': user.to_dict()
        }), 200
    
    except NotUniqueError:
        return jsonify({'error': 'Email already in use'}), 409
    except ValidationError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@user_bp.route('/profile/password', methods=['PUT'])
@jwt_required()
def change_password():
    """Change user password
    ---
    tags:
      - Users
    security:
      - Bearer: []
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - currentPassword
            - newPassword
          properties:
            currentPassword:
              type: string
              description: Current password
              example: OldPassword123
            newPassword:
              type: string
              description: New password
              example: NewPassword456
    responses:
      200:
        description: Password changed successfully
        schema:
          type: object
          properties:
            message:
              type: string
      400:
        description: Current and new password are required
      401:
        description: Current password is incorrect
      404:
        description: User not found
      500:
        description: Internal server error
    """
    current_user_id = get_jwt_identity()
    user = User.objects(id=current_user_id).first()
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    data = request.get_json()
    
    # Validate required fields
    if not data.get('currentPassword') or not data.get('newPassword'):
        return jsonify({'error': 'Current and new password are required'}), 400
    
    # Check current password
    if not user.check_password(data['currentPassword']):
        return jsonify({'error': 'Current password is incorrect'}), 401
    
    try:
        user.set_password(data['newPassword'])
        user.save()
        
        return jsonify({'message': 'Password changed successfully'}), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@user_bp.route('/profile', methods=['DELETE'])
@jwt_required()
def delete_account():
    """Delete user account
    ---
    tags:
      - Users
    security:
      - Bearer: []
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - password
          properties:
            password:
              type: string
              description: Password confirmation
              example: MyPassword123
    responses:
      200:
        description: Account deleted successfully
        schema:
          type: object
          properties:
            message:
              type: string
      400:
        description: Password confirmation required
      401:
        description: Incorrect password
      404:
        description: User not found
      500:
        description: Internal server error
    """
    current_user_id = get_jwt_identity()
    user = User.objects(id=current_user_id).first()
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    data = request.get_json()
    
    # Require password confirmation
    if not data.get('password'):
        return jsonify({'error': 'Password confirmation required'}), 400
    
    if not user.check_password(data['password']):
        return jsonify({'error': 'Incorrect password'}), 401
    
    try:
        user.delete()
        
        return jsonify({'message': 'Account deleted successfully'}), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@user_bp.route('/<user_id>', methods=['GET'])
@jwt_required()
def get_user(user_id):
    """Get user by ID (public profile)
    ---
    tags:
      - Users
    security:
      - Bearer: []
    parameters:
      - name: user_id
        in: path
        type: string
        required: true
        description: User ID
    responses:
      200:
        description: User public profile
        schema:
          type: object
          properties:
            id:
              type: string
            name:
              type: string
      400:
        description: Invalid user ID
      401:
        description: Unauthorized
      404:
        description: User not found
    """
    try:
        user = User.objects(id=user_id).first()
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Return limited public info
        return jsonify({
            'id': str(user.id),
            'name': user.name
        }), 200
    except Exception:
        return jsonify({'error': 'Invalid user ID'}), 400
