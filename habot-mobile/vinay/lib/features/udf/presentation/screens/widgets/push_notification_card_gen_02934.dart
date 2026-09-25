// GEN-02934 — Push Notification Status Card for Cited Research Report.
// Displays M3 Elevated Card with status chip indicating task completion state for push notification delivery. Implements single-column mobile layout (<600dp) and multi-column desktop (>=840dp) with 48x48dp touch targets, background polling every 30 seconds, and pull-to-refresh.

import 'dart:async';
import 'package:flutter/material.dart';

enum TaskCompletionStatus { complete, partial, notComplete }

class MockPushNotificationData {
  final String reportId;
  final String reportTitle;
  final TaskCompletionStatus status;
  final DateTime timestamp;
  final String traceId;

  const MockPushNotificationData({
    required this.reportId,
    required this.reportTitle,
    required this.status,
    required this.timestamp,
    required this.traceId,
  });
}

class MockPushNotificationRepository {
  static const List<MockPushNotificationData> _mockData = [
    MockPushNotificationData(
      reportId: 'RPT-001',
      reportTitle: 'Q3 Market Analysis Research Report',
      status: TaskCompletionStatus.complete,
      timestamp: null as dynamic,
      traceId: 'trace-abc-123',
    ),
    MockPushNotificationData(
      reportId: 'RPT-002',
      reportTitle: 'Annual Compliance Review Document',
      status: TaskCompletionStatus.partial,
      timestamp: null as dynamic,
      traceId: 'trace-def-456',
    ),
    MockPushNotificationData(
      reportId: 'RPT-003',
      reportTitle: 'Infrastructure Audit Findings',
      status: TaskCompletionStatus.notComplete,
      timestamp: null as dynamic,
      traceId: 'trace-ghi-789',
    ),
  ];

  static List<MockPushNotificationData> getNotifications() {
    final now = DateTime.now();
    return _mockData.map((e) => MockPushNotificationData(
      reportId: e.reportId,
      reportTitle: e.reportTitle,
      status: e.status,
      timestamp: now.subtract(Duration(minutes: _mockData.indexOf(e) * 15)),
      traceId: e.traceId,
    )).toList();
  }
}

class PushNotificationCardGen02934 extends StatefulWidget {
  const PushNotificationCardGen02934({super.key});

  @override
  State<PushNotificationCardGen02934> createState() => _PushNotificationCardGen02934State();
}

class _PushNotificationCardGen02934State extends State<PushNotificationCardGen02934> {
  late List<MockPushNotificationData> _notifications;
  Timer? _pollingTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _notifications = MockPushNotificationRepository.getNotifications();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refreshData(showIndicator: false);
    });
  }

  Future<void> _refreshData({bool showIndicator = true}) async {
    if (!mounted) return;
    if (showIndicator) setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _notifications = MockPushNotificationRepository.getNotifications();
      _isRefreshing = false;
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Color _getStatusColor(TaskCompletionStatus status, ColorScheme cs) {
    switch (status) {
      case TaskCompletionStatus.complete:
        return cs.primary;
      case TaskCompletionStatus.partial:
        return cs.tertiary;
      case TaskCompletionStatus.notComplete:
        return cs.error;
    }
  }

  String _getStatusLabel(TaskCompletionStatus status) {
    switch (status) {
      case TaskCompletionStatus.complete:
        return 'Complete';
      case TaskCompletionStatus.partial:
        return 'Partial';
      case TaskCompletionStatus.notComplete:
        return 'Not Complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notifications'),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(showIndicator: true),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 840;
            final crossAxisCount = isDesktop ? 2 : 1;

            return CustomScrollView(
              slivers: [
                if (_isRefreshing)
                  const SliverToBoxAdapter(
                    child: LinearProgressIndicator(),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: isDesktop ? 2.5 : 3.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = _notifications[index];
                        return _buildElevatedCard(item, cs, theme);
                      },
                      childCount: _notifications.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildElevatedCard(
    MockPushNotificationData item,
    ColorScheme cs,
    ThemeData theme,
  ) {
    return Card(
      elevation: 3.0,
      surfaceTintColor: cs.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Drill-down for ${item.reportId}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.reportTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 48,
                    width: 48,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.notifications_active_rounded,
                      color: _getStatusColor(item.status, cs),
                      size: 28,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    avatar: Icon(
                      item.status == TaskCompletionStatus.complete
                          ? Icons.check_circle
                          : item.status == TaskCompletionStatus.partial
                              ? Icons.pending
                              : Icons.error_outline,
                      size: 18,
                      color: _getStatusColor(item.status, cs),
                    ),
                    label: Text(
                      _getStatusLabel(item.status),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: _getStatusColor(item.status, cs),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: _getStatusColor(item.status, cs).withOpacity(0.12),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  Text(
                    'Trace: ${item.traceId}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
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
}
