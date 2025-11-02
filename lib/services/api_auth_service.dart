import 'package:get/get.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class ApiAuthService extends GetxService {
  final ApiService _api = ApiService();

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? role,
  }) async {
    try {
      final response = await _api.post(
        '/auth/register', // Real auth endpoint
        data: {
          'email': email,
          'password': password,
          'name': name,
          if (phone != null) 'phone': phone,
          if (role != null) 'role': role,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        // Save tokens
        _api.saveToken(data['access_token']);

        return {
          'success': true,
          'user': UserModel.fromJson(data['user']),
          'message': data['message'],
        };
      }

      return {'success': false, 'message': 'Registration failed'};
    } catch (e) {
      print('Register error: $e');
      String errorMessage = 'Registration failed';

      if (e.toString().contains('409')) {
        errorMessage = 'Email already registered';
      } else if (e.toString().contains('400')) {
        errorMessage = 'Invalid data provided';
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _api.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Save tokens
        _api.saveToken(data['access_token']);

        return {
          'success': true,
          'user': UserModel.fromJson(data['user']),
          'message': data['message'],
        };
      }

      return {'success': false, 'message': 'Login failed'};
    } catch (e) {
      print('Login error: $e');
      String errorMessage = 'Login failed';

      if (e.toString().contains('401')) {
        errorMessage = 'Invalid email or password';
      } else if (e.toString().contains('400')) {
        errorMessage = 'Please fill in all fields';
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _api.get('/auth/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      }

      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  /// Logout
  Future<void> logout() async {
    _api.clearToken();
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _api.getToken() != null;
  }
}
