import 'package:get/get.dart';
import '../models/ticket_model.dart';
import '../services/api_ticket_service.dart';

class TicketsController extends GetxController {
  final ApiTicketService _ticketService = ApiTicketService();
  
  final selectedFilter = 'upcoming'.obs;
  final allTickets = <TicketModel>[].obs;
  final isLoading = false.obs;

  List<TicketModel> get filteredTickets {
    switch (selectedFilter.value) {
      case 'upcoming':
        return allTickets.where((ticket) => ticket.isUpcoming).toList();
      case 'past':
        return allTickets.where((ticket) => ticket.isPast).toList();
      case 'expired':
        return allTickets.where((ticket) => ticket.isExpired).toList();
      default:
        return allTickets;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadTickets();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  Future<void> loadTickets() async {
    isLoading.value = true;
    try {
      final tickets = await _ticketService.getUserTickets();
      allTickets.assignAll(tickets);
    } catch (e) {
      print('❌ Load tickets error: $e');
      Get.snackbar('Error', 'Failed to load tickets');
    } finally {
    isLoading.value = false;
    }
  }

  Future<void> refreshTickets() async {
    await loadTickets();
  }
}
