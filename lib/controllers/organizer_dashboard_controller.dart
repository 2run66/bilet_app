import 'package:get/get.dart';
import '../services/api_organizer_service.dart';
import '../models/event_model.dart';

class OrganizerDashboardController extends GetxController {
  final ApiOrganizerService _organizerService = ApiOrganizerService();

  final isLoading = false.obs;
  final myEvents = <EventModel>[].obs;
  final stats = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadMyEvents(),
        loadStats(),
      ]);
      print('✅ Dashboard loaded: ${myEvents.length} events, stats: $stats');
    } catch (e) {
      print('❌ Load dashboard error: $e');
      print('Stack trace: ${StackTrace.current}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMyEvents() async {
    try {
      print('🔍 Loading organizer events...');
      final events = await _organizerService.getOrganizerEvents(limit: 10);
      print('✅ Loaded ${events.length} organizer events');
      myEvents.assignAll(events);
    } catch (e) {
      print('❌ Load my events error: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> loadStats() async {
    try {
      final result = await _organizerService.getOrganizerStats();
      if (result['success']) {
        stats.value = result['stats'];
      }
    } catch (e) {
      print('❌ Load stats error: $e');
    }
  }

  Future<void> refreshDashboard() async {
    await loadDashboard();
  }

  int get totalEvents => stats['totalEvents'] ?? 0;
  int get upcomingEvents => stats['upcomingEvents'] ?? 0;
  int get totalTicketsSold => stats['totalTicketsSold'] ?? 0;
  double get totalRevenue => (stats['totalRevenue'] ?? 0).toDouble();
}

