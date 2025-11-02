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
}
