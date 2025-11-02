import 'package:get/get.dart';
import '../services/api_organizer_service.dart';
import '../models/event_model.dart';

class EventAttendeesController extends GetxController {
  final ApiOrganizerService _organizerService = ApiOrganizerService();

  final isLoading = false.obs;
  final attendees = <Map<String, dynamic>>[].obs;
  final eventInfo = Rx<Map<String, dynamic>?>(null);
  final totalAttendees = 0.obs;

  late String eventId;
  late EventModel event;

  @override
  void onInit() {
    super.onInit();
    
    // Get event from arguments
    final args = Get.arguments;
    if (args is Map) {
      event = args['event'] as EventModel;
      eventId = event.id;
      loadAttendees();
    }
  }

  Future<void> loadAttendees() async {
    isLoading.value = true;
    try {
      print('🔍 Loading attendees for event: $eventId');
      final result = await _organizerService.getEventAttendees(eventId);

      if (result['success']) {
        attendees.value = List<Map<String, dynamic>>.from(result['attendees']);
        eventInfo.value = result['event'];
        totalAttendees.value = result['total'];
        print('✅ Loaded ${attendees.length} attendees');
      } else {
        Get.snackbar(
          'Error',
          'Failed to load attendees',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Load attendees error: $e');
      Get.snackbar(
        'Error',
        'Failed to load attendees',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAttendees() async {
    await loadAttendees();
  }

  List<Map<String, dynamic>> get activeAttendees =>
      attendees.where((a) => a['status'] == 'active').toList();

  List<Map<String, dynamic>> get usedAttendees =>
      attendees.where((a) => a['status'] == 'used').toList();

  List<Map<String, dynamic>> get cancelledAttendees =>
      attendees.where((a) => a['status'] == 'cancelled').toList();
}

