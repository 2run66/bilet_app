import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../services/api_organizer_service.dart';
import '../utils/app_colors.dart';

class QRScannerController extends GetxController {
  final ApiOrganizerService _organizerService = ApiOrganizerService();

  QRViewController? qrViewController;
  final isScanning = true.obs;
  final isProcessing = false.obs;
  final scannedCode = ''.obs;

  void onQRViewCreated(QRViewController controller) {
    qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isProcessing.value && scanData.code != null && isScanning.value) {
        onQRScanned(scanData.code!);
      }
    });
  }

  Future<void> onQRScanned(String code) async {
    if (isProcessing.value) return;

    isProcessing.value = true;
    scannedCode.value = code;

    // Pause scanning while processing
    qrViewController?.pauseCamera();

    try {
      print('🔍 Scanning QR code: $code');
      final result = await _organizerService.validateTicket(code);

      if (result['success'] && result['valid'] == true) {
        // Valid ticket
        _showSuccessDialog(result);
      } else {
        // Invalid ticket
        _showErrorDialog(result['message'] ?? 'Invalid ticket', result);
      }
    } catch (e) {
      print('❌ QR scan error: $e');
      _showErrorDialog('Failed to validate ticket', {});
    } finally {
      isProcessing.value = false;
      // Resume scanning after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        qrViewController?.resumeCamera();
      });
    }
  }

  void _showSuccessDialog(Map<String, dynamic> result) {
    final ticket = result['ticket'];
    Get.snackbar(
      'Valid Ticket ✓',
      ticket != null
          ? 'Event: ${ticket['eventTitle']}\nAttendee: ${ticket['userName']}'
          : result['message'] ?? 'Ticket validated successfully',
      backgroundColor: AppColors.success,
      colorText: AppColors.textOnPrimary,
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
    );
  }

  void _showErrorDialog(String message, Map<String, dynamic> result) {
    final ticket = result['ticket'];
    Get.snackbar(
      'Invalid Ticket ✗',
      ticket != null
          ? '$message\nEvent: ${ticket['eventTitle']}\nStatus: ${ticket['status']}'
          : message,
      backgroundColor: AppColors.error,
      colorText: AppColors.textOnPrimary,
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
    );
  }

  void toggleFlash() {
    qrViewController?.toggleFlash();
  }

  void flipCamera() {
    qrViewController?.flipCamera();
  }

  @override
  void onClose() {
    isScanning.value = false;
    qrViewController?.dispose();
    qrViewController = null;
    super.onClose();
  }
  
  void pauseScanning() {
    isScanning.value = false;
    qrViewController?.pauseCamera();
  }
  
  void resumeScanning() {
    isScanning.value = true;
    qrViewController?.resumeCamera();
  }
}
