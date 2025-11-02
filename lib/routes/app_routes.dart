part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const HOME = _Paths.HOME;
  static const MAIN = _Paths.MAIN;
  static const MY_TICKETS = _Paths.MY_TICKETS;
  static const TICKET_DETAIL = _Paths.TICKET_DETAIL;
  static const BROWSE = _Paths.BROWSE;
  static const EVENT_DETAIL = _Paths.EVENT_DETAIL;
  static const CHECKOUT = _Paths.CHECKOUT;
  static const ACCOUNT = _Paths.ACCOUNT;
  
  // Organizer routes
  static const ORGANIZER_DASHBOARD = _Paths.ORGANIZER_DASHBOARD;
  static const ORGANIZER_SCANNER = _Paths.ORGANIZER_SCANNER;
  static const ORGANIZER_CREATE_EVENT = _Paths.ORGANIZER_CREATE_EVENT;
  static const ORGANIZER_EVENT_ATTENDEES = _Paths.ORGANIZER_EVENT_ATTENDEES;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const HOME = '/home';
  static const MAIN = '/main';
  static const MY_TICKETS = '/tickets';
  static const TICKET_DETAIL = '/ticket-detail';
  static const BROWSE = '/browse';
  static const EVENT_DETAIL = '/event-detail';
  static const CHECKOUT = '/checkout';
  static const ACCOUNT = '/account';
  
  // Organizer paths
  static const ORGANIZER_DASHBOARD = '/organizer';
  static const ORGANIZER_SCANNER = '/organizer/scanner';
  static const ORGANIZER_CREATE_EVENT = '/organizer/create-event';
  static const ORGANIZER_EVENT_ATTENDEES = '/organizer/event-attendees';
}
