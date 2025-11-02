import 'package:get/get.dart';
import '../models/event_model.dart';
import 'api_service.dart';

class ApiEventService extends GetxService {
  final ApiService _api = ApiService();

  /// Get all events with optional filters
  Future<List<EventModel>> getAllEvents({
    String? category,
    bool? upcomingOnly,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null) queryParams['category'] = category;
      if (upcomingOnly != null) queryParams['upcoming'] = upcomingOnly;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      print('🌐 Fetching events with params: $queryParams');
      final response = await _api.get(
        '/events/',
        queryParameters: queryParams,
      );

      print('📡 Response status: ${response.statusCode}');
      print('📦 Response data type: ${response.data.runtimeType}');
      print('📦 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null) {
          print('⚠️ Response data is null');
          return [];
        }
        
        if (!responseData.containsKey('events')) {
          print('⚠️ Response does not contain "events" key. Keys: ${responseData.keys}');
          return [];
        }
        
        final List<dynamic> eventsData = responseData['events'];
        print('📦 Received ${eventsData.length} events');
        
        final events = <EventModel>[];
        for (var i = 0; i < eventsData.length; i++) {
          try {
            final event = EventModel.fromJson(eventsData[i]);
            events.add(event);
          } catch (e) {
            print('❌ Error parsing event $i: $e');
            print('Event data: ${eventsData[i]}');
          }
        }
        
        print('✅ Successfully parsed ${events.length} EventModel objects');
        return events;
      }

      print('⚠️ Non-200 status code');
      return [];
    } catch (e, stackTrace) {
      print('❌ Get all events error: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Get single event by ID
  Future<EventModel?> getEventById(String eventId) async {
    try {
      final response = await _api.get('/events/$eventId');

      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data['event']);
      }

      return null;
    } catch (e) {
      print('❌ Get event by ID error: $e');
      return null;
    }
  }

  /// Purchase ticket for an event
  Future<Map<String, dynamic>> purchaseTicket({
    required String eventId,
    int quantity = 1,
  }) async {
    try {
      final response = await _api.post(
        '/tickets',
        data: {
          'event_id': eventId,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data['message'],
          'tickets': response.data['tickets'],
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Purchase failed'
      };
    } catch (e) {
      print('❌ Purchase ticket error: $e');
      String errorMessage = 'Failed to purchase ticket';

      if (e.toString().contains('400')) {
        errorMessage = 'Invalid request';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Event not found';
      } else if (e.toString().contains('402')) {
        errorMessage = 'Payment required';
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  /// Get all events with optional filters
  Future<List<EventModel>> getEvents({
    String? category,
    String? search,
    bool upcomingOnly = false,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (category != null) 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
        if (upcomingOnly) 'upcoming': 'true',
      };

      final response = await _api.get('/events/', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final List events = response.data['events'];
        return events.map((e) => EventModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print('Get events error: $e');
      return [];
    }
  }

  /// Get single event by ID
  Future<EventModel?> getEvent(String eventId) async {
    try {
      final response = await _api.get('/events/$eventId');

      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('Get event error: $e');
      return null;
    }
  }

  /// Get all event categories
  Future<List<String>> getCategories() async {
    try {
      final response = await _api.get('/events/categories');

      if (response.statusCode == 200) {
        final List<dynamic> categories = response.data['categories'];
        return categories.map((e) => e.toString()).toList();
      }

      return [];
    } catch (e) {
      print('Get categories error: $e');
      return [];
    }
  }

  /// Create new event (admin only)
  Future<EventModel?> createEvent(Map<String, dynamic> eventData) async {
    try {
      final response = await _api.post('/events/', data: eventData);

      if (response.statusCode == 201) {
        return EventModel.fromJson(response.data['event']);
      }

      return null;
    } catch (e) {
      print('Create event error: $e');
      return null;
    }
  }

  /// Update event (admin only)
  Future<EventModel?> updateEvent(
      String eventId, Map<String, dynamic> eventData) async {
    try {
      final response = await _api.put('/events/$eventId', data: eventData);

      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data['event']);
      }

      return null;
    } catch (e) {
      print('Update event error: $e');
      return null;
    }
  }

  /// Delete event (admin only)
  Future<bool> deleteEvent(String eventId) async {
    try {
      final response = await _api.delete('/events/$eventId');
      return response.statusCode == 200;
    } catch (e) {
      print('Delete event error: $e');
      return false;
    }
  }
}

