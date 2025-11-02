import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_organizer_service.dart';
import '../controllers/organizer_dashboard_controller.dart';
import '../utils/app_colors.dart';

class CreateEventController extends GetxController {
  final ApiOrganizerService _organizerService = ApiOrganizerService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  final availableTicketsController = TextEditingController();
  final imageUrlController = TextEditingController();

  final selectedCategory = 'Music'.obs;
  final selectedDate = Rx<DateTime?>(null);
  final isLoading = false.obs;

  final categories = [
    'Music',
    'Sports',
    'Conference',
    'Theater',
    'Festival',
    'Workshop',
    'Other'
  ];

  Future<void> createEvent() async {
    // Validation
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        locationController.text.isEmpty ||
        priceController.text.isEmpty ||
        availableTicketsController.text.isEmpty ||
        selectedDate.value == null) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: AppColors.error,
        colorText: AppColors.textOnPrimary,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await _organizerService.createEvent(
        title: titleController.text,
        description: descriptionController.text,
        category: selectedCategory.value,
        location: locationController.text,
        date: selectedDate.value!,
        price: double.parse(priceController.text),
        availableTickets: int.parse(availableTicketsController.text),
        imageUrl: imageUrlController.text.isNotEmpty
            ? imageUrlController.text
            : null,
      );

      if (result['success']) {
        Get.snackbar(
          'Success',
          result['message'] ?? 'Event created successfully',
          backgroundColor: AppColors.success,
          colorText: AppColors.textOnPrimary,
        );
        
        // Refresh the dashboard and go back
        try {
          final dashboardController = Get.find<OrganizerDashboardController>();
          dashboardController.refreshDashboard();
        } catch (e) {
          print('Dashboard controller not found, will refresh on return');
        }
        
        Get.back(); // Go back to organizer dashboard
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to create event',
          backgroundColor: AppColors.error,
          colorText: AppColors.textOnPrimary,
        );
      }
    } catch (e) {
      print('❌ Create event error: $e');
      Get.snackbar(
        'Error',
        'Failed to create event',
        backgroundColor: AppColors.error,
        colorText: AppColors.textOnPrimary,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.surface,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 19, minute: 0),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppColors.primary,
                onPrimary: AppColors.textOnPrimary,
                surface: AppColors.surface,
                onSurface: AppColors.textPrimary,
              ),
              dialogBackgroundColor: AppColors.surface,
            ),
            child: child!,
          );
        },
      );

      if (timePicked != null) {
        selectedDate.value = DateTime(
          picked.year,
          picked.month,
          picked.day,
          timePicked.hour,
          timePicked.minute,
        );
      }
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    priceController.dispose();
    availableTicketsController.dispose();
    imageUrlController.dispose();
    super.onClose();
  }
}

