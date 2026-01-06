import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../utils/app_colors.dart';
import '../../models/ticket_model.dart';

class TicketDetailPage extends StatelessWidget {
  const TicketDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get ticket from arguments
    final ticket = Get.arguments as TicketModel?;

    if (ticket == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          title: const Text('Ticket Details'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Ticket not found',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'Go Back',
                  style: TextStyle(color: AppColors.textOnPrimary),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: Text(
          'Ticket Details',
          style: TextStyle(color: AppColors.textOnPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: AppColors.textOnPrimary),
            onPressed: () {
              Get.snackbar(
                'Share',
                'Share functionality coming soon!',
                backgroundColor: AppColors.info,
                colorText: AppColors.textOnPrimary,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Ticket Card with QR Code
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.ticketGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(ticket.status),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ticket.status.name.toUpperCase(),
                            style: TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Event Title
                        Text(
                          ticket.eventTitle,
                          style: TextStyle(
                            color: AppColors.textOnPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 24),

                        // QR Code
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.textOnPrimary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // Generate QR Code from ticket qrCode data
                              QrImageView(
                                data: ticket.qrCode,
                                version: QrVersions.auto,
                                size: 200,
                                backgroundColor: Colors.white,
                                errorCorrectionLevel: QrErrorCorrectLevel.M,
                                padding: const EdgeInsets.all(8),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Ticket ID: ${ticket.id.substring(0, 12).toUpperCase()}',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Dotted Line Separator
                  _buildDottedLine(),

                  // Event Details Section
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildDetailItem(
                          Icons.calendar_today,
                          'Date & Time',
                          ticket.formattedDate,
                        ),
                        const SizedBox(height: 16),
                        _buildDetailItem(
                          Icons.location_on,
                          'Location',
                          ticket.eventLocation,
                        ),
                        if (ticket.seatNumber != null) ...[
                          const SizedBox(height: 16),
                          _buildDetailItem(
                            Icons.event_seat,
                            'Seat',
                            ticket.seatNumber!,
                          ),
                        ],
                        const SizedBox(height: 16),
                        _buildDetailItem(
                          Icons.attach_money,
                          'Price Paid',
                          '\$${ticket.price.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Additional Info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Important Information',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem('• Arrive 30 minutes before the event'),
                  _buildInfoItem('• Bring a valid photo ID'),
                  _buildInfoItem('• Show this QR code at the entrance'),
                  _buildInfoItem('• No outside food or drinks allowed'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.snackbar(
                        'Calendar',
                        'Event added to your calendar!',
                        backgroundColor: AppColors.success,
                        colorText: AppColors.textOnPrimary,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                      Icons.calendar_month,
                      color: AppColors.textOnPrimary,
                    ),
                    label: Text(
                      'Add to Calendar',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      Get.snackbar(
                        'Download',
                        'Ticket saved to your device!',
                        backgroundColor: AppColors.info,
                        colorText: AppColors.textOnPrimary,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary, width: 2),
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.download, color: AppColors.primary),
                    label: Text(
                      'Download Ticket',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.active:
        return AppColors.ticketActive;
      case TicketStatus.used:
        return AppColors.ticketUsed;
      case TicketStatus.expired:
        return AppColors.ticketExpired;
      case TicketStatus.pending:
        return AppColors.ticketPending;
    }
  }

  Widget _buildDottedLine() {
    return Row(
      children: List.generate(
        50,
        (index) => Expanded(
          child: Container(
            height: 2,
            color: index % 2 == 0
                ? AppColors.textOnPrimary.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.textOnPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.textOnPrimary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
    );
  }
}
