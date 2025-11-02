import 'package:get/get.dart';
import '../models/ticket_model.dart';
import 'api_service.dart';

class ApiTicketService extends GetxService {
  final ApiService _api = ApiService();

  /// Get all user tickets
  Future<List<TicketModel>> getUserTickets() async {
    try {
      final response = await _api.get('/tickets/');

      if (response.statusCode == 200) {
        final List<dynamic> ticketsData = response.data['tickets'];
        return ticketsData.map((json) => TicketModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('❌ Get user tickets error: $e');
      return [];
    }
  }

  /// Get single ticket by ID
  Future<TicketModel?> getTicketById(String ticketId) async {
    try {
      final response = await _api.get('/tickets/$ticketId');

      if (response.statusCode == 200) {
        return TicketModel.fromJson(response.data['ticket']);
      }

      return null;
    } catch (e) {
      print('❌ Get ticket by ID error: $e');
      return null;
    }
  }

  /// Validate/Use a ticket
  Future<Map<String, dynamic>> validateTicket(String ticketId) async {
    try {
      final response = await _api.post('/tickets/$ticketId/validate');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'],
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Validation failed'
      };
    } catch (e) {
      print('❌ Validate ticket error: $e');
      return {'success': false, 'message': 'Failed to validate ticket'};
    }
  }

  /// Get all tickets for current user
  Future<List<TicketModel>> getMyTickets({
    String? status,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (status != null) 'status': status,
      };

      final response =
          await _api.get('/tickets/', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final List tickets = response.data['tickets'];
        return tickets.map((t) => TicketModel.fromJson(t)).toList();
      }

      return [];
    } catch (e) {
      print('Get tickets error: $e');
      return [];
    }
  }

  /// Get single ticket by ID
  Future<TicketModel?> getTicket(String ticketId) async {
    try {
      final response = await _api.get('/tickets/$ticketId');

      if (response.statusCode == 200) {
        return TicketModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('Get ticket error: $e');
      return null;
    }
  }

  /// Purchase a ticket
  Future<Map<String, dynamic>> purchaseTicket({
    required String eventId,
    String? seatNumber,
  }) async {
    try {
      final response = await _api.post('/tickets/purchase', data: {
        'eventId': eventId,
        if (seatNumber != null) 'seatNumber': seatNumber,
      });

      if (response.statusCode == 201) {
        return {
          'success': true,
          'ticket': TicketModel.fromJson(response.data['ticket']),
          'message': response.data['message'],
        };
      }

      return {'success': false, 'message': 'Purchase failed'};
    } catch (e) {
      print('Purchase ticket error: $e');
      String errorMessage = 'Purchase failed';
      
      if (e.toString().contains('400')) {
        errorMessage = 'No tickets available or invalid event';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Please login first';
      }
      
      return {'success': false, 'message': errorMessage};
    }
  }

  /// Activate a pending ticket
  Future<bool> activateTicket(String ticketId) async {
    try {
      final response = await _api.post('/tickets/$ticketId/activate');
      return response.statusCode == 200;
    } catch (e) {
      print('Activate ticket error: $e');
      return false;
    }
  }

  /// Update ticket status
  Future<bool> updateTicketStatus(String ticketId, String status) async {
    try {
      final response = await _api.patch('/tickets/$ticketId/status', data: {
        'status': status,
      });
      return response.statusCode == 200;
    } catch (e) {
      print('Update ticket status error: $e');
      return false;
    }
  }

  /// Cancel/delete ticket
  Future<bool> cancelTicket(String ticketId) async {
    try {
      final response = await _api.delete('/tickets/$ticketId');
      return response.statusCode == 200;
    } catch (e) {
      print('Cancel ticket error: $e');
      return false;
    }
  }

  /// Mark ticket as used (for organizers)
  Future<bool> useTicket(String ticketId) async {
    try {
      final response = await _api.post('/tickets/$ticketId/use');
      return response.statusCode == 200;
    } catch (e) {
      print('Use ticket error: $e');
      return false;
    }
  }
}

