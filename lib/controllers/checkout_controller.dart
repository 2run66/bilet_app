import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../services/api_event_service.dart';
import '../controllers/navigation_controller.dart';

class CheckoutController extends GetxController {
  final quantity = 1.obs;
  final selectedPaymentMethod = 'credit_card'.obs;
  final agreedToTerms = false.obs;
  final isProcessing = false.obs;

  // Dynamic ticket price (set from event data)
  final _ticketPrice = 0.0.obs;
  final double serviceFeePercentage = 0.10; // 10%

  double get ticketPrice => _ticketPrice.value;
  double get subtotal => ticketPrice * quantity.value;
  double get serviceFee => subtotal * serviceFeePercentage;
  double get totalPrice => subtotal + serviceFee;

  bool get canProceed =>
      agreedToTerms.value &&
      selectedPaymentMethod.value.isNotEmpty &&
      !isProcessing.value;

  void setTicketPrice(double price) {
    _ticketPrice.value = price;
  }

  void incrementQuantity() {
    if (quantity.value < 10) {
      // Max 10 tickets
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  Future<void> processPurchase(String eventId) async {
    if (!canProceed) return;

    isProcessing.value = true;

    try {
      print('🛒 Processing purchase for event: $eventId');

      // Call API to purchase ticket
      final eventService = Get.find<ApiEventService>();
      final result = await eventService.purchaseTicket(
        eventId: eventId,
        quantity: quantity.value,
      );

      print('🛒 Purchase result: $result');

      if (result['success']) {
        // Show success message
        Get.snackbar(
          'Success!',
          result['message'] ?? 'Your ticket has been purchased',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: AppColors.textOnPrimary,
          duration: const Duration(seconds: 3),
        );

        // Navigate to main shell with tickets tab selected
        Get.offAllNamed('/main');
        // Give time for navigation then switch tab
        Future.delayed(const Duration(milliseconds: 100), () {
          try {
            final navController = Get.find<NavigationController>();
            navController.changeTab(2); // Tickets tab
          } catch (e) {
            print('Nav controller not found: $e');
          }
        });
      } else {
        // Show error message
        Get.snackbar(
          'Purchase Failed',
          result['message'] ?? 'Failed to purchase ticket',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: AppColors.textOnPrimary,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('❌ Purchase error: $e');
      Get.snackbar(
        'Error',
        'Failed to process purchase. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.textOnPrimary,
      );
    } finally {
      isProcessing.value = false;
    }
  }
}
