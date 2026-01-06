from flask import Flask, jsonify
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flasgger import Swagger
from config import config
from models import db
import os


def create_app(config_name='default'):
    """Application factory"""
    app = Flask(__name__)
    
    # Load configuration
    app.config.from_object(config[config_name])
    
    # Initialize extensions
    db.init_app(app)
    CORS(app)
    JWTManager(app)
    
    # Swagger configuration
    swagger_config = {
        "headers": [],
        "specs": [
            {
                "endpoint": "apispec",
                "route": "/apispec.json",
                "rule_filter": lambda rule: True,
                "model_filter": lambda tag: True,
            }
        ],
        "static_url_path": "/flasgger_static",
        "swagger_ui": True,
        "specs_route": "/apidocs/"
    }
    
    swagger_template = {
        "swagger": "2.0",
        "info": {
            "title": "Bilet App API",
            "description": "API documentation for Bilet App - Event Ticketing Platform",
            "version": "1.0.0",
            "contact": {
                "name": "Bilet App Team"
            }
        },
        "basePath": "/api",
        "schemes": ["http", "https"],
        "securityDefinitions": {
            "Bearer": {
                "type": "apiKey",
                "name": "Authorization",
                "in": "header",
                "description": "JWT Authorization header using the Bearer scheme. Example: 'Bearer {token}'"
            }
        }
    }
    
    Swagger(app, config=swagger_config, template=swagger_template)
    
    # Register blueprints
    from routes.auth_routes import auth_bp
    from routes.event_routes import event_bp
    from routes.ticket_routes import ticket_bp
    from routes.user_routes import user_bp
    from routes.mock_auth_routes import mock_auth_bp
    from routes.organizer_routes import organizer_bp
    
    app.register_blueprint(auth_bp)
    app.register_blueprint(event_bp)
    app.register_blueprint(ticket_bp)
    app.register_blueprint(user_bp)
    app.register_blueprint(mock_auth_bp)  # Mock auth for testing without DB
    app.register_blueprint(organizer_bp)  # Organizer routes
    
    # Health check endpoint
    @app.route('/api/health', methods=['GET'])
    def health_check():
        """Health check endpoint
        ---
        tags:
          - System
        responses:
          200:
            description: API health status
            schema:
              type: object
              properties:
                status:
                  type: string
                  example: healthy
                message:
                  type: string
                  example: Bilet App API is running
        """
        return jsonify({
            'status': 'healthy',
            'message': 'Bilet App API is running'
        }), 200
    
    # Root endpoint
    @app.route('/', methods=['GET'])
    def index():
        """Root endpoint with API information
        ---
        tags:
          - System
        responses:
          200:
            description: API information and available endpoints
            schema:
              type: object
              properties:
                message:
                  type: string
                version:
                  type: string
                documentation:
                  type: string
                endpoints:
                  type: object
        """
        return jsonify({
            'message': 'Welcome to Bilet App API',
            'version': '1.0.0',
            'documentation': '/apidocs/',
            'endpoints': {
                'auth': '/api/auth',
                'events': '/api/events',
                'tickets': '/api/tickets',
                'users': '/api/users',
                'organizer': '/api/organizer'
            }
        }), 200
    
    # Error handlers
    @app.errorhandler(404)
    def not_found(error):
        return jsonify({'error': 'Resource not found'}), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({'error': 'Internal server error'}), 500
    
    return app


if __name__ == '__main__':
    # Get environment from ENV variable, default to development
    env = os.getenv('FLASK_ENV', 'development')
    app = create_app(env)
    
    # Run the application
    port = int(os.getenv('PORT', 5050))
    app.run(host='0.0.0.0', port=port, debug=(env == 'development'))

