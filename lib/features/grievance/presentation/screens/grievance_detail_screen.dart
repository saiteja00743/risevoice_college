import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../domain/entities/grievance.dart';

class GrievanceDetailScreen extends StatelessWidget {
  final Grievance grievance;

  const GrievanceDetailScreen({
    super.key,
    required this.grievance,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(grievance.status);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grievance Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              // TODO: Share grievance
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  statusColor,
                  statusColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getStatusIcon(grievance.status),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatStatus(grievance.status),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(
                      'ID: ${grievance.id}',
                      Icons.tag_rounded,
                    ),
                    const SizedBox(width: 8),
                    if (grievance.isAnonymous)
                      _buildInfoChip(
                        'Anonymous',
                        Icons.visibility_off_rounded,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Title & Category
          Text(
            'Grievance Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.category_rounded,
                          color: AppTheme.primaryBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              grievance.category,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    grievance.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    grievance.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Attachments
          if (grievance.attachments.isNotEmpty) ...[
            Text(
              'Attachments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...grievance.attachments.map((attachment) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(
                    Icons.attach_file_rounded,
                    color: AppTheme.primaryBlue,
                  ),
                  title: Text(attachment),
                  trailing: IconButton(
                    icon: const Icon(Icons.download_rounded),
                    onPressed: () {
                      // TODO: Download attachment
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],

          // Timeline
          Text(
            'Timeline',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTimelineItem(
                    context,
                    icon: Icons.add_circle_outline,
                    title: 'Grievance Submitted',
                    date: grievance.createdAt,
                    isFirst: true,
                  ),
                  if (grievance.status != AppConstants.statusPending)
                    _buildTimelineItem(
                      context,
                      icon: Icons.visibility_rounded,
                      title: 'Under Review',
                      date: grievance.updatedAt,
                    ),
                  if (grievance.status == AppConstants.statusResolved)
                    _buildTimelineItem(
                      context,
                      icon: Icons.check_circle_rounded,
                      title: 'Resolved',
                      date: grievance.resolvedAt ?? grievance.updatedAt,
                      color: AppTheme.successGreen,
                      isLast: true,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Updates
          if (grievance.updates.isNotEmpty) ...[
            Text(
              'Updates',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...grievance.updates.map((update) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 16,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  update.updatedByRole ?? 'Committee Member',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  DateFormat('MMM dd, yyyy • hh:mm a')
                                      .format(update.createdAt),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        update.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],

          // Action Buttons
          const SizedBox(height: 24),
          if (grievance.status != AppConstants.statusResolved &&
              grievance.status != AppConstants.statusRejected)
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Navigate to chat
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: const Text('Chat with Committee'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required DateTime date,
    Color? color,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final itemColor = color ?? AppTheme.primaryBlue;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 12,
                  color: Colors.grey.shade300,
                ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: itemColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: itemColor, width: 2),
                ),
                child: Icon(icon, size: 16, color: itemColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy • hh:mm a').format(date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.statusPending:
        return AppTheme.warningOrange;
      case AppConstants.statusUnderReview:
        return AppTheme.infoBlue;
      case AppConstants.statusInProgress:
        return AppTheme.primaryTeal;
      case AppConstants.statusResolved:
        return AppTheme.successGreen;
      case AppConstants.statusRejected:
        return AppTheme.errorRed;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case AppConstants.statusPending:
        return Icons.pending_outlined;
      case AppConstants.statusUnderReview:
        return Icons.visibility_rounded;
      case AppConstants.statusInProgress:
        return Icons.autorenew_rounded;
      case AppConstants.statusResolved:
        return Icons.check_circle_rounded;
      case AppConstants.statusRejected:
        return Icons.cancel_rounded;
      default:
        return Icons.info_outline;
    }
  }

  String _formatStatus(String status) {
    return status.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
