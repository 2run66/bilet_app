import 'package:get/get.dart';
import '../utils/app_colors.dart';

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

  Future<void> processPurchase() async {
    if (!canProceed) return;

    isProcessing.value = true;

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    isProcessing.value = false;

    // Show success message
    Get.snackbar(
      'Success!',
      'Your ticket has been purchased',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: AppColors.textOnPrimary,
      duration: const Duration(seconds: 3),
    );

    // TODO: Navigate to ticket detail or my tickets page
    // Get.offAllNamed('/tickets');
  }
}
