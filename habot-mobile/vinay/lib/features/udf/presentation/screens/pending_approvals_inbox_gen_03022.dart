// GEN-03022 — Mobile Pending Approvals Inbox View.
// Builds and displays the mobile Pending Approvals inbox view using M3 Elevated Cards, Status Chips, pull-to-refresh, and 30-second background polling. Single-column layout with 48x48dp touch targets.

import 'dart:async';
import 'package:flutter/material.dart';

enum ApprovalStatus { pending, approved, rejected }

class ApprovalItem {
  final String id;
  final String title;
  final String description;
  final String requester;
  final DateTime submittedAt;
  final ApprovalStatus status;

  const ApprovalItem({
    required this.id,
    required this.title,
    required this.description,
    required this.requester,
    required this.submittedAt,
    required this.status,
  });
}

class MockApprovalRepository {
  static List<ApprovalItem> getMockApprovals() {
    return [
      ApprovalItem(
        id: 'APR-001',
        title: 'Infrastructure Change Request',
        description: 'Upgrade production database cluster to v15.',
        requester: 'Alice Johnson',
        submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: ApprovalStatus.pending,
      ),
      ApprovalItem(
        id: 'APR-002',
        title: 'Security Patch Deployment',
        description: 'Apply critical CVE-2026-1234 patch to edge nodes.',
        requester: 'Bob Smith',
        submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
        status: ApprovalStatus.approved,
      ),
      ApprovalItem(
        id: 'APR-003',
        title: 'Network ACL Update',
        description: 'Open port 8443 for new microservice communication.',
        requester: 'Charlie Davis',
        submittedAt: DateTime.now().subtract(const Duration(days: 1)),
        status: ApprovalStatus.rejected,
      ),
      ApprovalItem(
        id: 'APR-004',
        title: 'CI/CD Pipeline Modification',
        description: 'Add SonarQube quality gate to deployment workflow.',
        requester: 'Diana Prince',
        submittedAt: DateTime.now().subtract(const Duration(minutes: 45)),
        status: ApprovalStatus.pending,
      ),
    ];
  }
}

class PendingApprovalsInboxScreen extends StatefulWidget {
  const PendingApprovalsInboxScreen({super.key});

  @override
  State<PendingApprovalsInboxScreen> createState() => _PendingApprovalsInboxScreenState();
}

class _PendingApprovalsInboxScreenState extends State<PendingApprovalsInboxScreen> {
  late List<ApprovalItem> _approvals;
  bool _isLoading = false;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _approvals = MockApprovalRepository.getMockApprovals();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refreshData(showIndicator: false);
    });
  }

  Future<void> _refreshData({bool showIndicator = true}) async {
    if (showIndicator) {
      setState(() => _isLoading = true);
    }
    // Simulate API latency < 100ms
    await Future.delayed(const Duration(milliseconds: 80));
    if (!mounted) return;
    setState(() {
      _approvals = MockApprovalRepository.getMockApprovals();
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Color _getStatusColor(ApprovalStatus status, ThemeData theme) {
    switch (status) {
      case ApprovalStatus.pending:
        return theme.colorScheme.tertiary;
      case ApprovalStatus.approved:
        return theme.colorScheme.primary;
      case ApprovalStatus.rejected:
        return theme.colorScheme.error;
    }
  }

  String _getStatusText(ApprovalStatus status) {
    switch (status) {
      case ApprovalStatus.pending:
        return 'Pending';
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.rejected:
        return 'Rejected';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Approvals'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Manual Sync',
            onPressed: () => _refreshData(showIndicator: true),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoading && _approvals.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _approvals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _approvals[index];
                  return _buildApprovalCard(item, theme);
                },
              ),
      ),
    );
  }

  Widget _buildApprovalCard(ApprovalItem item, ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetailsBottomSheet(item, theme),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      _getStatusText(item.status),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: _getStatusColor(item.status, theme),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    item.requester,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    _formatTimeAgo(item.submittedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsBottomSheet(ApprovalItem item, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Approval Details', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('ID: ${item.id}', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('Title: ${item.title}', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Description: ${item.description}', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('Requester: ${item.requester}', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('Status: ${_getStatusText(item.status)}', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Deep-link drill-down triggered for ${item.id}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('View Full Record'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
