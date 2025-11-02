import 'package:get/get.dart';
import '../views/auth/splash_page.dart';
import '../views/auth/login_page.dart';
import '../views/auth/register_page.dart';
import '../views/auth/forgot_password_page.dart';
import '../views/home/home_page.dart';
import '../views/home/main_shell_page.dart';
import '../views/tickets/my_tickets_page.dart';
import '../views/tickets/ticket_detail_page.dart';
import '../views/events/browse_events_page.dart';
import '../views/events/event_detail_page.dart';
import '../views/checkout/checkout_page.dart';
import '../views/account/account_page.dart';
import '../views/organizer/organizer_dashboard_page.dart';
import '../views/organizer/qr_scanner_page.dart';
import '../views/organizer/create_event_page.dart';
import '../views/organizer/event_attendees_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.SPLASH, page: () => const SplashPage()),
    GetPage(name: _Paths.LOGIN, page: () => const LoginPage()),
    GetPage(name: _Paths.REGISTER, page: () => const RegisterPage()),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordPage(),
    ),
    GetPage(name: _Paths.HOME, page: () => const HomePage()),
    GetPage(name: _Paths.MAIN, page: () => const MainShellPage()),
    GetPage(name: _Paths.MY_TICKETS, page: () => const MyTicketsPage()),
    GetPage(name: _Paths.TICKET_DETAIL, page: () => const TicketDetailPage()),
    GetPage(name: _Paths.BROWSE, page: () => const BrowseEventsPage()),
    GetPage(name: _Paths.EVENT_DETAIL, page: () => const EventDetailPage()),
    GetPage(name: _Paths.CHECKOUT, page: () => const CheckoutPage()),
    GetPage(name: _Paths.ACCOUNT, page: () => const AccountPage()),
    
    // Organizer routes
    GetPage(name: _Paths.ORGANIZER_DASHBOARD, page: () => const OrganizerDashboardPage()),
    GetPage(name: _Paths.ORGANIZER_SCANNER, page: () => const QRScannerPage()),
    GetPage(name: _Paths.ORGANIZER_CREATE_EVENT, page: () => const CreateEventPage()),
    GetPage(name: _Paths.ORGANIZER_EVENT_ATTENDEES, page: () => const EventAttendeesPage()),
  ];
}
