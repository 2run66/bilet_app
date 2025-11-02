import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for 2 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is authenticated
    final authService = Get.find<AuthService>();

    if (authService.isAuthenticated) {
      Get.offAllNamed(Routes.MAIN);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Icon(
              Icons.confirmation_number_outlined,
              size: 120,
              color: AppColors.textOnPrimary,
            ),
            const SizedBox(height: 24),
            // App Name
            Text(
              'Bilet App',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your Event Tickets',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 48),
            // Loading Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
