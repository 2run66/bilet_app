import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import 'api_auth_service.dart';

class AuthService extends GetxService {
  final _storage = GetStorage();
  final _apiAuth = ApiAuthService();
  final _currentUser = Rxn<UserModel>();

  UserModel? get currentUser => _currentUser.value;
  bool get isAuthenticated =>
      _currentUser.value != null && _apiAuth.isAuthenticated();

  // Storage keys
  static const String _userKey = 'current_user';

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  // Load user from storage on app start
  void _loadUserFromStorage() async {
    final userData = _storage.read(_userKey);
    if (userData != null && _apiAuth.isAuthenticated()) {
      _currentUser.value = UserModel.fromJson(
        Map<String, dynamic>.from(userData),
      );

      // Verify token is still valid by fetching current user
      final user = await _apiAuth.getCurrentUser();
      if (user != null) {
        _currentUser.value = user;
        await _storage.write(_userKey, user.toJson());
      } else {
        // Token invalid, logout
        await logout();
      }
    }
  }

  // Login with API
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final result = await _apiAuth.login(email, password);

      if (result['success']) {
        _currentUser.value = result['user'];
        await _storage.write(_userKey, result['user'].toJson());
      }

      return result;
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'Login failed: $e'};
    }
  }

  // Register with API
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? role,
  }) async {
    try {
      final result = await _apiAuth.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
      );

      if (result['success']) {
        _currentUser.value = result['user'];
        await _storage.write(_userKey, result['user'].toJson());
      }

      return result;
    } catch (e) {
      print('Register error: $e');
      return {'success': false, 'message': 'Registration failed: $e'};
    }
  }

  // Forgot Password (TODO: Implement in backend)
  Future<bool> resetPassword(String email) async {
    try {
      // This endpoint doesn't exist in backend yet
      // For now, return false
      return false;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _currentUser.value = null;
    await _storage.remove(_userKey);
    await _apiAuth.logout();
  }

  // Update user profile
  Future<bool> updateProfile(UserModel updatedUser) async {
    try {
      _currentUser.value = updatedUser;
      await _storage.write(_userKey, updatedUser.toJson());
      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  // Refresh current user data from API
  Future<void> refreshUser() async {
    final user = await _apiAuth.getCurrentUser();
    if (user != null) {
      _currentUser.value = user;
      await _storage.write(_userKey, user.toJson());
    }
  }

  // Clear all data (useful for testing)
  Future<void> clearAllData() async {
    await _storage.erase();
    _currentUser.value = null;
    await _apiAuth.logout();
  }
}
