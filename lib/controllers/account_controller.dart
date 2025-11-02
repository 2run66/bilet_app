import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class AccountController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  var userName = 'John Doe'.obs;
  var userEmail = 'john.doe@example.com'.obs;
  var userPhone = '+1 234 567 8900'.obs;
  var notificationsEnabled = true.obs;
  var darkModeEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    // Load from auth service
    if (_authService.isAuthenticated) {
      userName.value = _authService.currentUser?.name ?? 'User';
      userEmail.value = _authService.currentUser?.email ?? '';
      userPhone.value = _authService.currentUser?.phone ?? '';
    }
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    // TODO: Save to storage
  }

  void toggleDarkMode(bool value) {
    darkModeEnabled.value = value;
    // TODO: Save to storage and update theme
  }

  void logout() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _authService.logout();
      Get.offAllNamed('/login');
    }
  }

  void editProfile() {
    // TODO: Navigate to edit profile page
    Get.snackbar(
      'Edit Profile',
      'Profile editing coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void changePassword() {
    // TODO: Navigate to change password page
    Get.snackbar(
      'Change Password',
      'Password change coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

