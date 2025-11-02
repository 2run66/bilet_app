import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/tickets_controller.dart';

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TicketsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: Text(
          'My Tickets',
          style: TextStyle(color: AppColors.textOnPrimary),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: AppColors.surface,
            child: Obx(
              () => Row(
                children: [
                  _buildFilterTab(
                    'Upcoming',
                    controller.selectedFilter.value == 'upcoming',
                    () => controller.setFilter('upcoming'),
                  ),
                  _buildFilterTab(
                    'Past',
                    controller.selectedFilter.value == 'past',
                    () => controller.setFilter('past'),
                  ),
                  _buildFilterTab(
                    'Expired',
                    controller.selectedFilter.value == 'expired',
                    () => controller.setFilter('expired'),
                  ),
                ],
              ),
            ),
          ),

          // Tickets List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (controller.filteredTickets.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.refreshTickets,
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = controller.filteredTickets[index];
                    return _buildTicketItem(ticket);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketItem(dynamic ticket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: AppColors.ticketGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed('/ticket-detail');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.confirmation_number,
                            color: AppColors.textOnPrimary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'TICKET',
                            style: TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge('Active'),
                  ],
                ),
                const SizedBox(height: 20),

                // Event Title
                Text(
                  'Summer Music Festival 2024',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Event Details
                _buildDetailRow(
                  Icons.calendar_today,
                  'December 25, 2024 • 8:00 PM',
                ),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.location_on, 'Central Park, New York'),
                const SizedBox(height: 8),
                _buildDetailRow(
                  Icons.event_seat,
                  'Section A • Row 5 • Seat 12',
                ),
                const SizedBox(height: 20),

                // Action Button
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/ticket-detail');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textOnPrimary,
                    foregroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Details & QR Code',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.textOnPrimary.withValues(alpha: 0.9),
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'active':
        statusColor = AppColors.ticketActive;
        break;
      case 'used':
        statusColor = AppColors.ticketUsed;
        break;
      case 'expired':
        statusColor = AppColors.ticketExpired;
        break;
      default:
        statusColor = AppColors.ticketPending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No Tickets Found',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start exploring events and get your tickets!',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Get.toNamed('/browse');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Browse Events'),
          ),
        ],
      ),
    );
  }
}
