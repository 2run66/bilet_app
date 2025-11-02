import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  final _storage = GetStorage();
  final _currentUser = Rxn<UserModel>();

  UserModel? get currentUser => _currentUser.value;
  bool get isAuthenticated => _currentUser.value != null;

  // Storage keys
  static const String _userKey = 'current_user';
  static const String _usersKey = 'registered_users';
  static const String _tokenKey = 'auth_token';

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  // Load user from storage on app start
  void _loadUserFromStorage() {
    final userData = _storage.read(_userKey);
    if (userData != null) {
      _currentUser.value = UserModel.fromJson(
        Map<String, dynamic>.from(userData),
      );
    }
  }

  // Mock Login - checks against stored users
  Future<bool> login(String email, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Get all registered users
      final users = _storage.read<List>(_usersKey) ?? [];

      // Find user with matching email and password
      final userMap = users.firstWhereOrNull(
        (user) => user['email'] == email && user['password'] == password,
      );

      if (userMap != null) {
        final user = UserModel.fromJson(Map<String, dynamic>.from(userMap));
        _currentUser.value = user;

        // Save to storage
        await _storage.write(_userKey, user.toJson());
        await _storage.write(_tokenKey, 'mock_token_${user.id}');

        return true;
      }

      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Mock Register - stores user locally
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Get existing users
      final users = _storage.read<List>(_usersKey) ?? [];

      // Check if email already exists
      final emailExists = users.any((user) => user['email'] == email);
      if (emailExists) {
        return false;
      }

      // Create new user
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        phone: phone,
        createdAt: DateTime.now(),
      );

      // Store user with password (in real app, never store plain password!)
      final userWithPassword = {...newUser.toJson(), 'password': password};

      users.add(userWithPassword);
      await _storage.write(_usersKey, users);

      // Auto login after registration
      _currentUser.value = newUser;
      await _storage.write(_userKey, newUser.toJson());
      await _storage.write(_tokenKey, 'mock_token_${newUser.id}');

      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  // Mock Forgot Password
  Future<bool> resetPassword(String email) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if email exists
      final users = _storage.read<List>(_usersKey) ?? [];
      final emailExists = users.any((user) => user['email'] == email);

      return emailExists;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _currentUser.value = null;
    await _storage.remove(_userKey);
    await _storage.remove(_tokenKey);
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

  // Clear all data (useful for testing)
  Future<void> clearAllData() async {
    await _storage.erase();
    _currentUser.value = null;
  }
}
