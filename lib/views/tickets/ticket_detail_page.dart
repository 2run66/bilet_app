import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class TicketDetailPage extends StatelessWidget {
  const TicketDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              // TODO: Implement share functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.textOnPrimary),
            onPressed: () {
              // TODO: Show more options
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
                            color: AppColors.ticketActive,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'ACTIVE',
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
                          'Summer Music Festival 2024',
                          style: TextStyle(
                            color: AppColors.textOnPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
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
                              // TODO: Add QR code widget
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.qr_code_2,
                                        size: 80,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'QR Code',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Ticket ID: TKT-2024-001234',
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
                          'December 25, 2024\n8:00 PM - 11:00 PM',
                        ),
                        const SizedBox(height: 16),
                        _buildDetailItem(
                          Icons.location_on,
                          'Location',
                          'Central Park\nNew York, NY 10024',
                        ),
                        const SizedBox(height: 16),
                        _buildDetailItem(
                          Icons.event_seat,
                          'Seat',
                          'Section A • Row 5 • Seat 12',
                        ),
                        const SizedBox(height: 16),
                        _buildDetailItem(Icons.person, 'Attendee', 'John Doe'),
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
                  _buildInfoItem('• No outside food or drinks allowed'),
                  _buildInfoItem(
                    '• Screenshots of QR code will not be accepted',
                  ),
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
                      // TODO: Add to calendar
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
                      // TODO: Download ticket
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
