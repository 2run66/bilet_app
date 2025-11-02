import 'package:get/get.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class ApiUserService extends GetxService {
  final ApiService _api = ApiService();

  /// Get current user profile
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _api.get('/users/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      }

      return null;
    } catch (e) {
      print('❌ Get current user error: $e');
      return null;
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;

      final response = await _api.put('/users/me', data: data);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'user': UserModel.fromJson(response.data['user']),
          'message': response.data['message'],
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Update failed',
      };
    } catch (e) {
      print('❌ Update profile error: $e');
      return {'success': false, 'message': 'Failed to update profile'};
    }
  }

  /// Change password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _api.put(
        '/users/profile/password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.data['message']};
      }

      return {'success': false, 'message': 'Password change failed'};
    } catch (e) {
      print('Change password error: $e');
      String errorMessage = 'Password change failed';

      if (e.toString().contains('401')) {
        errorMessage = 'Current password is incorrect';
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  /// Delete account
  Future<Map<String, dynamic>> deleteAccount(String password) async {
    try {
      final response = await _api.delete('/users/profile');

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.data['message']};
      }

      return {'success': false, 'message': 'Account deletion failed'};
    } catch (e) {
      print('Delete account error: $e');
      String errorMessage = 'Account deletion failed';

      if (e.toString().contains('401')) {
        errorMessage = 'Incorrect password';
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  /// Get public user profile by ID
  Future<Map<String, dynamic>?> getPublicProfile(String userId) async {
    try {
      final response = await _api.get('/users/$userId');

      if (response.statusCode == 200) {
        return response.data;
      }

      return null;
    } catch (e) {
      print('Get public profile error: $e');
      return null;
    }
  }
}
