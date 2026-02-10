import 'package:flutter/material.dart';
import 'package:rise_voice/core/theme/app_theme.dart';
import 'package:rise_voice/core/constants/app_constants.dart';
import '../../domain/entities/grievance.dart';
import 'grievance_detail_screen.dart';

class MyGrievancesScreen extends StatefulWidget {
  const MyGrievancesScreen({super.key});

  @override
  State<MyGrievancesScreen> createState() => _MyGrievancesScreenState();
}

class _MyGrievancesScreenState extends State<MyGrievancesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data
  final List<Grievance> _mockGrievances = [
    Grievance(
      id: '1',
      userId: 'user123',
      title: 'Library AC not working',
      description: 'The air conditioning in the library has been broken for 3 days',
      category: 'Infrastructure',
      status: AppConstants.statusPending,
      priority: AppConstants.priorityMedium,
      isAnonymous: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      updates: [],
    ),
    Grievance(
      id: '2',
      userId: null,
      title: 'Harassment complaint',
      description: 'Anonymous complaint about inappropriate behavior',
      category: 'Ragging/Harassment',
      status: AppConstants.statusUnderReview,
      priority: AppConstants.priorityHigh,
      isAnonymous: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
      updates: [],
    ),
    Grievance(
      id: '3',
      userId: 'user123',
      title: 'Exam schedule conflict',
      description: 'Two exams scheduled at the same time',
      category: 'Examination',
      status: AppConstants.statusResolved,
      priority: AppConstants.priorityLow,
      isAnonymous: false,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      resolvedAt: DateTime.now().subtract(const Duration(days: 3)),
      updates: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Grievance> _filterGrievances(String status) {
    if (status == 'all') return _mockGrievances;
    return _mockGrievances.where((g) => g.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Grievances'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Resolved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGrievanceList(_filterGrievances('all')),
          _buildGrievanceList(_filterGrievances(AppConstants.statusPending)),
          _buildGrievanceList(_filterGrievances(AppConstants.statusInProgress)),
          _buildGrievanceList(_filterGrievances(AppConstants.statusResolved)),
        ],
      ),
    );
  }

  Widget _buildGrievanceList(List<Grievance> grievances) {
    if (grievances.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No grievances found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grievances.length,
      itemBuilder: (context, index) {
        final grievance = grievances[index];
        return _buildGrievanceCard(grievance);
      },
    );
  }

  Widget _buildGrievanceCard(Grievance grievance) {
    final statusColor = _getStatusColor(grievance.status);
    final priorityColor = _getPriorityColor(grievance.priority);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GrievanceDetailScreen(grievance: grievance),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Anonymous Badge
                  if (grievance.isAnonymous)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility_off_rounded,
                            size: 14,
                            color: AppTheme.primaryTeal,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Anonymous',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.primaryTeal,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  
                  // Priority Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      grievance.priority.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: priorityColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                grievance.title,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Category
              Row(
                children: [
                  Icon(
                    Icons.category_rounded,
                    size: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    grievance.category,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Footer Row
              Row(
                children: [
                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatStatus(grievance.status),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  
                  // Date
                  Text(
                    _formatDate(grievance.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
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

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case AppConstants.priorityLow:
        return AppTheme.successGreen;
      case AppConstants.priorityMedium:
        return AppTheme.warningOrange;
      case AppConstants.priorityHigh:
        return AppTheme.errorRed;
      case AppConstants.priorityUrgent:
        return AppTheme.errorRed;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    return status.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
