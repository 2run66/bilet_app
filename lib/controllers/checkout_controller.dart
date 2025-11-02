import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../services/api_event_service.dart';

class CheckoutController extends GetxController {
  final quantity = 1.obs;
  final selectedPaymentMethod = 'credit_card'.obs;
  final agreedToTerms = false.obs;
  final isProcessing = false.obs;

  final double ticketPrice = 25.0;
  final double serviceFeePercentage = 0.10; // 10%

  double get subtotal => ticketPrice * quantity.value;
  double get serviceFee => subtotal * serviceFeePercentage;
  double get totalPrice => subtotal + serviceFee;

  bool get canProceed =>
      agreedToTerms.value &&
      selectedPaymentMethod.value.isNotEmpty &&
      !isProcessing.value;

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
      // Call API to purchase ticket
      final eventService = Get.find<ApiEventService>();
      final result = await eventService.purchaseTicket(
        eventId: eventId,
        quantity: quantity.value,
      );

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

        // Navigate to tickets page
        Get.offAllNamed('/tickets');
      } else {
        // Show error message
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to purchase ticket',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: AppColors.textOnPrimary,
        );
      }
    } catch (e) {
      print('❌ Purchase error: $e');
      Get.snackbar(
        'Error',
        'Failed to process purchase',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.textOnPrimary,
      );
    } finally {
      isProcessing.value = false;
    }
  }
}
