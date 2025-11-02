"""
Test MongoDB Atlas connection
Run with: python test_mongodb_connection.py
"""
from pymongo import MongoClient
from pymongo.server_api import ServerApi
import os
from dotenv import load_dotenv

load_dotenv()

def test_connection():
    """Test MongoDB connection"""
    print("🔍 Testing MongoDB Atlas connection...\n")
    
    uri = os.getenv('MONGODB_URI')
    
    if not uri:
        print("❌ Error: MONGODB_URI not found in .env file")
        return False
    
    print(f"📡 Connecting to: {uri.split('@')[1].split('?')[0]}...")  # Hide credentials
    
    try:
        # Create a new client and connect to the server
        client = MongoClient(uri, server_api=ServerApi('1'))
        
        # Send a ping to confirm a successful connection
        client.admin.command('ping')
        print("✅ Successfully connected to MongoDB Atlas!")
        
        # Get database info
        db = client['bilet_app']
        print(f"\n📊 Database: bilet_app")
        print(f"   Collections: {db.list_collection_names() or 'None (empty database)'}")
        
        # Test write operation
        test_collection = db['connection_test']
        test_doc = {'test': 'connection', 'timestamp': 'success'}
        result = test_collection.insert_one(test_doc)
        print(f"\n✅ Write test successful! Document ID: {result.inserted_id}")
        
        # Clean up test document
        test_collection.delete_one({'_id': result.inserted_id})
        print("✅ Cleanup successful!")
        
        client.close()
        
        print("\n" + "="*50)
        print("🎉 All tests passed! MongoDB is ready to use.")
        print("="*50)
        
        return True
        
    except Exception as e:
        print(f"\n❌ Connection failed: {e}")
        print("\n💡 Troubleshooting:")
        print("   1. Check your internet connection")
        print("   2. Verify MongoDB Atlas credentials")
        print("   3. Ensure your IP is whitelisted in MongoDB Atlas")
        print("   4. Check if the cluster is active")
        return False


if __name__ == '__main__':
    success = test_connection()
    exit(0 if success else 1)

