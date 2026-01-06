import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/api_event_service.dart';
import '../services/api_ticket_service.dart';
import '../models/event_model.dart';
import '../models/ticket_model.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ApiEventService _eventService = ApiEventService();
  final ApiTicketService _ticketService = ApiTicketService();

  final userName = ''.obs;
  final activeTickets = <TicketModel>[].obs;
  final upcomingEvents = <EventModel>[].obs;
  final featuredEvents = <EventModel>[].obs;
  final categories = <String>["All", "Music", "Tech", "Sports", "Theatre"].obs;
  final selectedCategory = "All".obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadTickets();
    _loadEvents();
  }

  void _loadUserData() {
    final user = _authService.currentUser;
    if (user != null) {
      userName.value = user.name;
    }
  }

  Future<void> _loadTickets() async {
    try {
      final tickets = await _ticketService.getUserTickets();
      activeTickets.assignAll(tickets.where((t) => t.isUpcoming));
    } catch (e) {
      print('❌ Load tickets error: $e');
    }
  }

  Future<void> _loadEvents() async {
    try {
      print('🔍 Loading events from API...');
      // Load upcoming events from API
      final events = await _eventService.getAllEvents(
        upcomingOnly: true,
        limit: 20,
      );

      print('✅ Loaded ${events.length} events from API');
      upcomingEvents.assignAll(events);
      featuredEvents.assignAll(events.take(3));
    } catch (e) {
      print('❌ Load events error: $e');
      print('Stack trace: ${StackTrace.current}');
      // Fallback to mock data if API fails
      _loadMockEvents();
    }
  }

  Future<void> _loadMockEvents() async {
    // Fallback mock data if API is unavailable
    final now = DateTime.now();
    final mock = <EventModel>[
      EventModel(
        id: 'e1',
        title: 'Summer Music Festival',
        description: 'A day full of music and vibes.',
        category: 'Music',
        location: 'Central Park, NY',
        date: now.add(const Duration(days: 10)),
        price: 49.99,
        imageUrl: 'https://picsum.photos/seed/music1/800/450',
        availableTickets: 120,
        organizerName: 'LiveNation',
      ),
      EventModel(
        id: 'e2',
        title: 'Tech Conference 2025',
        description: 'Talks, workshops, and networking.',
        category: 'Tech',
        location: 'Convention Center',
        date: now.add(const Duration(days: 30)),
        price: 199.0,
        imageUrl: 'https://picsum.photos/seed/tech1/800/450',
        availableTickets: 300,
        organizerName: 'TechOrg',
      ),
      EventModel(
        id: 'e3',
        title: 'City Marathon',
        description: 'Join the annual city marathon.',
        category: 'Sports',
        location: 'Downtown',
        date: now.add(const Duration(days: 20)),
        price: 20.0,
        imageUrl: 'https://picsum.photos/seed/run1/800/450',
        availableTickets: 50,
        organizerName: 'City Sports',
      ),
      EventModel(
        id: 'e4',
        title: 'Shakespeare in the Park',
        description: 'An evening of classic theatre.',
        category: 'Theatre',
        location: 'Open Air Stage',
        date: now.add(const Duration(days: 5)),
        price: 35.0,
        imageUrl: 'https://picsum.photos/seed/theatre1/800/450',
        availableTickets: 80,
        organizerName: 'Drama Club',
      ),
    ];

    upcomingEvents.assignAll(mock.where((e) => e.isUpcoming));
    featuredEvents.assignAll(mock.take(3));
    return Future.value();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    await Future.wait([_loadTickets(), _loadEvents()]);
    isLoading.value = false;
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void selectCategory(String value) {
    selectedCategory.value = value;
  }

  List<EventModel> get filteredUpcomingEvents {
    return upcomingEvents.where((event) {
      final matchQuery =
          searchQuery.value.isEmpty ||
          event.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          event.location.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );
      final matchCategory =
          selectedCategory.value == 'All' ||
          event.category == selectedCategory.value;
      return matchQuery && matchCategory;
    }).toList();
  }
}
