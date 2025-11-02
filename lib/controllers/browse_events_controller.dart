import 'package:get/get.dart';

class BrowseEventsController extends GetxController {
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;
  final allEvents = [].obs;
  final isLoading = false.obs;

  final categories = <String>[
    'All',
    'Music',
    'Sports',
    'Theatre',
    'Conference',
    'Festival',
  ].obs;

  List get filteredEvents {
    var events = allEvents.where((event) {
      // Filter by search
      if (searchQuery.value.isNotEmpty) {
        // TODO: Implement actual search
        return true;
      }
      return true;
    }).toList();

    // Filter by category
    if (selectedCategory.value != 'All') {
      // TODO: Implement category filter
    }

    return events;
  }

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  void search(String query) {
    searchQuery.value = query;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> loadEvents() async {
    isLoading.value = true;
    // TODO: Load events from storage/API
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }

  Future<void> refreshEvents() async {
    await loadEvents();
  }
}
