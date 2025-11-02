import 'package:get/get.dart';
import '../models/event_model.dart';
import 'api_service.dart';

class ApiOrganizerService extends GetxService {
  final ApiService _api = ApiService();

  /// Get organizer's events
  Future<List<EventModel>> getOrganizerEvents({int? page, int? limit}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      print('🌐 Fetching organizer events...');
      final response = await _api.get(
        '/organizer/events',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> eventsData = response.data['events'];
        print('✅ Loaded ${eventsData.length} organizer events');
        return eventsData.map((json) => EventModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('❌ Get organizer events error: $e');
      return [];
    }
  }

  /// Create a new event
  Future<Map<String, dynamic>> createEvent({
    required String title,
    required String description,
    required String category,
    required String location,
    required DateTime date,
    required double price,
    required int availableTickets,
    String? imageUrl,
  }) async {
    try {
      print('🌐 Creating event: $title');
      final response = await _api.post(
        '/organizer/events',
        data: {
          'title': title,
          'description': description,
          'category': category,
          'location': location,
          'date': date.toIso8601String(),
          'price': price,
          'availableTickets': availableTickets,
          if (imageUrl != null) 'imageUrl': imageUrl,
        },
      );

      if (response.statusCode == 201) {
        print('✅ Event created successfully');
        return {
          'success': true,
          'event': EventModel.fromJson(response.data['event']),
          'message': response.data['message'] ?? 'Event created successfully',
        };
      }

      return {
        'success': false,
        'message': 'Failed to create event',
      };
    } catch (e) {
      print('❌ Create event error: $e');
      String errorMessage = 'Failed to create event';

      if (e.toString().contains('403')) {
        errorMessage = 'Organizer access required';
      } else if (e.toString().contains('400')) {
        errorMessage = 'Invalid event data';
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  /// Update an event
  Future<Map<String, dynamic>> updateEvent({
    required String eventId,
    String? title,
    String? description,
    String? category,
    String? location,
    DateTime? date,
    double? price,
    int? availableTickets,
    String? imageUrl,
  }) async {
    try {
      print('🌐 Updating event: $eventId');
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (category != null) data['category'] = category;
      if (location != null) data['location'] = location;
      if (date != null) data['date'] = date.toIso8601String();
      if (price != null) data['price'] = price;
      if (availableTickets != null) data['availableTickets'] = availableTickets;
      if (imageUrl != null) data['imageUrl'] = imageUrl;

      final response = await _api.put(
        '/organizer/events/$eventId',
        data: data,
      );

      if (response.statusCode == 200) {
        print('✅ Event updated successfully');
        return {
          'success': true,
          'event': EventModel.fromJson(response.data['event']),
          'message': response.data['message'] ?? 'Event updated successfully',
        };
      }

      return {
        'success': false,
        'message': 'Failed to update event',
      };
    } catch (e) {
      print('❌ Update event error: $e');
      String errorMessage = 'Failed to update event';

      if (e.toString().contains('403')) {
        errorMessage = 'Unauthorized';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Event not found';
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  /// Delete an event
  Future<Map<String, dynamic>> deleteEvent(String eventId) async {
    try {
      print('🌐 Deleting event: $eventId');
      final response = await _api.delete('/organizer/events/$eventId');

      if (response.statusCode == 200) {
        print('✅ Event deleted successfully');
        return {
          'success': true,
          'message': response.data['message'] ?? 'Event deleted successfully',
        };
      }

      return {
        'success': false,
        'message': 'Failed to delete event',
      };
    } catch (e) {
      print('❌ Delete event error: $e');
      String errorMessage = 'Failed to delete event';

      if (e.toString().contains('403')) {
        errorMessage = 'Unauthorized';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Event not found';
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  /// Get event attendees
  Future<Map<String, dynamic>> getEventAttendees(String eventId) async {
    try {
      print('🌐 Fetching attendees for event: $eventId');
      final response = await _api.get('/organizer/events/$eventId/attendees');

      if (response.statusCode == 200) {
        print('✅ Loaded ${response.data['total']} attendees');
        return {
          'success': true,
          'event': response.data['event'],
          'attendees': response.data['attendees'] as List<dynamic>,
          'total': response.data['total'],
        };
      }

      return {
        'success': false,
        'attendees': [],
        'total': 0,
      };
    } catch (e) {
      print('❌ Get attendees error: $e');
      return {
        'success': false,
        'attendees': [],
        'total': 0,
      };
    }
  }

  /// Validate a ticket (scan QR code)
  Future<Map<String, dynamic>> validateTicket(String qrCode) async {
    try {
      print('🌐 Validating ticket: $qrCode');
      final response = await _api.post(
        '/organizer/validate-ticket',
        data: {'qrCode': qrCode},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print('✅ Ticket validation result: ${data['valid']}');
        return {
          'success': true,
          'valid': data['valid'],
          'message': data['message'],
          'ticket': data['ticket'],
        };
      }

      return {
        'success': false,
        'valid': false,
        'message': 'Failed to validate ticket',
      };
    } catch (e) {
      print('❌ Validate ticket error: $e');
      String errorMessage = 'Failed to validate ticket';

      if (e.toString().contains('404')) {
        errorMessage = 'Ticket not found';
      } else if (e.toString().contains('403')) {
        errorMessage = 'Organizer access required';
      }

      return {
        'success': false,
        'valid': false,
        'message': errorMessage,
      };
    }
  }

  /// Get organizer statistics
  Future<Map<String, dynamic>> getOrganizerStats() async {
    try {
      print('🌐 Fetching organizer stats...');
      final response = await _api.get('/organizer/stats');

      if (response.statusCode == 200) {
        print('✅ Loaded organizer stats');
        return {
          'success': true,
          'stats': response.data,
        };
      }

      return {
        'success': false,
        'stats': {},
      };
    } catch (e) {
      print('❌ Get organizer stats error: $e');
      return {
        'success': false,
        'stats': {},
      };
    }
  }
}

