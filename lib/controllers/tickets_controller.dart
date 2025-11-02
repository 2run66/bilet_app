import 'package:get/get.dart';

class TicketsController extends GetxController {
  final selectedFilter = 'upcoming'.obs;
  final allTickets = [].obs;
  final isLoading = false.obs;

  List get filteredTickets {
    switch (selectedFilter.value) {
      case 'upcoming':
        return allTickets
            .where((ticket) => true)
            .toList(); // TODO: Filter upcoming
      case 'past':
        return allTickets
            .where((ticket) => false)
            .toList(); // TODO: Filter past
      case 'expired':
        return allTickets
            .where((ticket) => false)
            .toList(); // TODO: Filter expired
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
    // TODO: Load tickets from storage/API
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }

  Future<void> refreshTickets() async {
    await loadTickets();
  }
}
