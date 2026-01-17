import 'package:get/get.dart';
import '../services/api_event_service.dart';
import '../models/event_model.dart';

class BrowseEventsController extends GetxController {
  final ApiEventService _eventService = ApiEventService();

  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;
  final allEvents = <EventModel>[].obs;
  final isLoading = false.obs;

  final categories = <String>[
    'All',
    'Music',
    'Sports',
    'Theatre',
    'Conference',
    'Festival',
  ].obs;

  List<EventModel> get filteredEvents {
    return allEvents.where((event) {
      // Filter by search query
      final matchesSearch =
          searchQuery.value.isEmpty ||
          event.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          event.description.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ) ||
          event.location.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );

      // Filter by category
      final matchesCategory =
          selectedCategory.value == 'All' ||
          event.category == selectedCategory.value;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  void search(String query) {
    searchQuery.value = query;
    // Optionally reload events with search parameter
  }

  void selectCategory(String category) {
    print('📂 Selecting category: $category');
    selectedCategory.value = category;
    print('📂 Current selected category: ${selectedCategory.value}');
    loadEvents(); // Reload with new category filter
  }

  Future<void> loadEvents() async {
    isLoading.value = true;
    try {
      print('🔍 [BrowseEvents] Loading events...');
      final events = await _eventService.getAllEvents(
        category: selectedCategory.value != 'All'
            ? selectedCategory.value
            : null,
      );
      print('✅ [BrowseEvents] Loaded ${events.length} events');
      allEvents.assignAll(events);
    } catch (e) {
      print('❌ [BrowseEvents] Load events error: $e');
      Get.snackbar('Error', 'Failed to load events');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshEvents() async {
    await loadEvents();
  }
}
