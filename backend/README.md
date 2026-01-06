# Bilet App Backend

Flask backend for the Bilet ticketing application with MongoDB Atlas.

## Setup

### Requirements
- Python 3.12 (due to SSL compatibility issues with MongoDB Atlas)

### Installation

1. **Create Python 3.12 environment:**
```bash
conda create -n bilet_py312 python=3.12 -y
conda activate bilet_py312
```

2. **Install dependencies:**
```bash
pip install -r requirements.txt
```

3. **Setup environment variables:**
```bash
# Run ONE of these depending on your OS:
chmod +x setup_env.sh && ./setup_env.sh  # macOS/Linux
setup_env.bat                             # Windows
```

4. **Seed the database (optional):**
```bash
python seed_data.py
```

## Running the Server

### Using the startup script (recommended):
```bash
./start_server.sh
```

### Manual start:
```bash
conda activate bilet_py312
python app.py
```

The server will run on `http://0.0.0.0:5050`

## Troubleshooting

### SSL Handshake Error with MongoDB Atlas

If you see `[SSL: TLSV1_ALERT_INTERNAL_ERROR]`:

1. **Check MongoDB Atlas Network Access:**
   - Log into MongoDB Atlas
   - Go to Network Access
   - Add your current IP or allow all IPs (`0.0.0.0/0`) for testing

2. **Verify Python version:**
   ```bash
   python --version  # Should be 3.12.x
   ```

3. **Test connection:**
   ```bash
   python -c "from pymongo import MongoClient; import certifi; c=MongoClient('YOUR_MONGODB_URI', tlsCAFile=certifi.where()); c.admin.command('ping'); print('Success!')"
   ```

## API Endpoints

- **Auth:** `/api/auth/register`, `/api/auth/login`
- **Events:** `/api/events/`
- **Tickets:** `/api/tickets/`
- **Users:** `/api/users/me`

## Project Structure

```
backend/
├── app.py              # Main Flask application
├── config.py           # Configuration settings
├── models/             # MongoDB models
│   ├── __init__.py
│   ├── user.py
│   ├── event.py
│   └── ticket.py
├── routes/             # API routes
│   ├── auth_routes.py
│   ├── event_routes.py
│   ├── ticket_routes.py
│   └── user_routes.py
├── utils/              # Utility functions
│   └── auth_utils.py
└── seed_data.py        # Database seeding script
```

## Development

The backend is configured for development mode by default. For production deployment, update the environment variables in `.env` and use a production WSGI server like Gunicorn.

