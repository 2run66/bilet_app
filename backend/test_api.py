"""
Simple API test script
Run with: python test_api.py
"""
import requests
import json
import os
from dotenv import load_dotenv

load_dotenv()

PORT = os.getenv('PORT', '5050')
BASE_URL = f'http://localhost:{PORT}/api'

def print_response(response, title="Response"):
    """Pretty print API response"""
    print(f"\n{'='*50}")
    print(f"{title}")
    print(f"{'='*50}")
    print(f"Status: {response.status_code}")
    try:
        print(f"Body: {json.dumps(response.json(), indent=2)}")
    except:
        print(f"Body: {response.text}")


def test_api():
    """Test API endpoints"""
    print("\n🧪 Testing Bilet App API...\n")
    
    # Test health check
    print("1️⃣ Testing health check...")
    response = requests.get(f'{BASE_URL}/health')
    print_response(response, "Health Check")
    
    # Test register
    print("\n2️⃣ Testing user registration...")
    register_data = {
        'email': 'test@example.com',
        'password': 'password123',
        'name': 'Test User',
        'phone': '+1234567890'
    }
    response = requests.post(f'{BASE_URL}/auth/register', json=register_data)
    print_response(response, "Register User")
    
    if response.status_code == 201:
        access_token = response.json()['access_token']
        print(f"\n✅ Access Token: {access_token[:50]}...")
        
        # Test get current user
        print("\n3️⃣ Testing get current user...")
        headers = {'Authorization': f'Bearer {access_token}'}
        response = requests.get(f'{BASE_URL}/auth/me', headers=headers)
        print_response(response, "Current User")
        
        # Test create event
        print("\n4️⃣ Testing create event...")
        event_data = {
            'title': 'Test Concert',
            'description': 'A test concert event',
            'category': 'Music',
            'location': 'Test Venue',
            'date': '2024-12-31T20:00:00Z',
            'price': 50.00,
            'imageUrl': 'https://example.com/image.jpg',
            'availableTickets': 100,
            'organizerName': 'Test Organizer'
        }
        response = requests.post(f'{BASE_URL}/events', json=event_data, headers=headers)
        print_response(response, "Create Event")
        
        if response.status_code == 201:
            event_id = response.json()['event']['id']
            
            # Test get events
            print("\n5️⃣ Testing get all events...")
            response = requests.get(f'{BASE_URL}/events')
            print_response(response, "Get All Events")
            
            # Test purchase ticket
            print("\n6️⃣ Testing ticket purchase...")
            ticket_data = {
                'eventId': event_id,
                'seatNumber': 'A12'
            }
            response = requests.post(f'{BASE_URL}/tickets/purchase', json=ticket_data, headers=headers)
            print_response(response, "Purchase Ticket")
            
            if response.status_code == 201:
                # Test get user tickets
                print("\n7️⃣ Testing get user tickets...")
                response = requests.get(f'{BASE_URL}/tickets', headers=headers)
                print_response(response, "Get User Tickets")
    
    else:
        # Try login if registration failed (user might already exist)
        print("\n2️⃣b Testing user login...")
        login_data = {
            'email': 'test@example.com',
            'password': 'password123'
        }
        response = requests.post(f'{BASE_URL}/auth/login', json=login_data)
        print_response(response, "Login User")
    
    print("\n\n✅ API tests completed!")


if __name__ == '__main__':
    try:
        test_api()
    except requests.exceptions.ConnectionError:
        print(f"\n❌ Error: Could not connect to API")
        print(f"Make sure the Flask server is running on http://localhost:{PORT}")
    except Exception as e:
        print(f"\n❌ Error: {e}")

