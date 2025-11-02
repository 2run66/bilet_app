import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/checkout_controller.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final eventData = Get.arguments as Map<String, dynamic>?;
    final eventId = eventData?['eventId'] as String? ?? 'e1';
    final eventTitle =
        eventData?['title'] as String? ?? 'Summer Music Festival 2024';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: Text(
          'Checkout',
          style: TextStyle(color: AppColors.textOnPrimary),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.ticketGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventTitle,
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Dec 25, 2024 • 8:00 PM',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.location_on, 'Central Park, NY'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Ticket Quantity
              Text(
                'Ticket Quantity',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Number of tickets',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          IconButton(
                            onPressed: controller.decrementQuantity,
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '${controller.quantity.value}',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: controller.incrementQuantity,
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment Method
              Text(
                'Payment Method',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Column(
                  children: [
                    _buildPaymentOption(
                      'Credit Card',
                      Icons.credit_card,
                      'credit_card',
                      controller,
                    ),
                    const SizedBox(height: 8),
                    _buildPaymentOption(
                      'Debit Card',
                      Icons.payment,
                      'debit_card',
                      controller,
                    ),
                    const SizedBox(height: 8),
                    _buildPaymentOption(
                      'PayPal',
                      Icons.account_balance_wallet,
                      'paypal',
                      controller,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Order Summary
              Text(
                'Order Summary',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Obx(
                  () => Column(
                    children: [
                      _buildSummaryRow('Ticket Price', '\$25.00', false),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        'Quantity',
                        '${controller.quantity.value}',
                        false,
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        'Service Fee',
                        '\$${controller.serviceFee.toStringAsFixed(2)}',
                        false,
                      ),
                      Divider(color: AppColors.divider, height: 32),
                      _buildSummaryRow(
                        'Total',
                        '\$${controller.totalPrice.toStringAsFixed(2)}',
                        true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Terms & Conditions
              Obx(
                () => CheckboxListTile(
                  value: controller.agreedToTerms.value,
                  onChanged: (value) {
                    controller.agreedToTerms.value = value ?? false;
                  },
                  activeColor: AppColors.primary,
                  title: Text(
                    'I agree to the Terms & Conditions',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 100), // Space for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.canProceed
                  ? () {
                      controller.processPurchase(eventId);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.buttonDisabled,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: controller.isProcessing.value
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.textOnPrimary,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Complete Purchase',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.textOnPrimary.withValues(alpha: 0.8),
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textOnPrimary.withValues(alpha: 0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    String label,
    IconData icon,
    String value,
    CheckoutController controller,
  ) {
    final isSelected = controller.selectedPaymentMethod.value == value;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: controller.selectedPaymentMethod.value,
        onChanged: (val) {
          controller.selectedPaymentMethod.value = val ?? '';
        },
        activeColor: AppColors.primary,
        title: Row(
          children: [
            Icon(icon, color: AppColors.textPrimary),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isBold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: isBold ? 18 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isBold ? AppColors.primary : AppColors.textPrimary,
            fontSize: isBold ? 24 : 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
