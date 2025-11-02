import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../utils/app_colors.dart';
import '../../controllers/qr_scanner_controller.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRScannerController? controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(QRScannerController());
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller?.qrViewController != null) {
      controller!.qrViewController!.pauseCamera();
      controller!.qrViewController!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) return const SizedBox.shrink();

    return WillPopScope(
      onWillPop: () async {
        controller?.pauseScanning();
        await Future.delayed(const Duration(milliseconds: 100));
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Scan Ticket',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          backgroundColor: AppColors.surface,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () {
              controller?.pauseScanning();
              Get.back();
            },
          ),
        ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
              QRView(
                key: qrKey,
                onQRViewCreated: controller!.onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: AppColors.primary,
                  borderRadius: 12,
                  borderLength: 30,
                  borderWidth: 8,
                  cutOutSize: 300,
                ),
              ),
              Obx(
                () => controller!.isProcessing.value
                      ? Container(
                          color: Colors.black54,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.surface,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Position the QR code within the frame',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: controller!.toggleFlash,
                        icon: Icon(
                          Icons.flash_on,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 32),
                      IconButton(
                        onPressed: controller!.flipCamera,
                        icon: Icon(
                          Icons.flip_camera_android,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => controller!.scannedCode.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Last scanned: ${controller!.scannedCode.value.substring(0, controller!.scannedCode.value.length > 20 ? 20 : controller!.scannedCode.value.length)}...',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

