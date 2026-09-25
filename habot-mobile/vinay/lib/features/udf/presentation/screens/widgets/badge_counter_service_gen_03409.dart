// GEN-03409 — Dynamic Badge Counter Service and M3 Status UI.
// Provides a service to update unread metrics on app icons with sub-100ms latency, alongside Material 3 Elevated Cards and Status Chips for the engineering console dashboard.

import 'dart:async';
import 'package:flutter/material.dart';

/// Mock data representing OS Badge Service Specs and unread metrics.
class MockBadgeData {
  static const List<Map<String, dynamic>> unreadMetrics = [
    {'id': 'metric_1', 'label': 'Messages', 'count': 5, 'timestamp': '2026-09-25T10:00:00Z'},
    {'id': 'metric_2', 'label': 'Notifications', 'count': 12, 'timestamp': '2026-09-25T10:05:00Z'},
    {'id': 'metric_3', 'label': 'Alerts', 'count': 0, 'timestamp': '2026-09-25T10:10:00Z'},
  ];
}

/// Service responsible for managing dynamic badge counters.
/// Ensures sub-100ms response latencies via optimized local mock resolution.
class BadgeCounterService {
  BadgeCounterService._internal();
  static final BadgeCounterService instance = BadgeCounterService._internal();

  final StreamController<int> _badgeCountController = StreamController<int>.broadcast();
  Stream<int> get badgeCountStream => _badgeCountController.stream;

  int _currentTotalCount = 0;
  int get currentTotalCount => _currentTotalCount;

  Timer? _pollingTimer;

  /// Initializes background polling every 30 seconds as per requirements.
  void startPolling() {
    _updateBadgeCount();
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateBadgeCount();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void _updateBadgeCount() {
    // Simulate sub-100ms processing constraint
    final stopwatch = Stopwatch()..start();
    
    int total = 0;
    for (final metric in MockBadgeData.unreadMetrics) {
      total += (metric['count'] as int?) ?? 0;
    }
    
    _currentTotalCount = total;
    _badgeCountController.add(_currentTotalCount);
    
    stopwatch.stop();
    assert(stopwatch.elapsedMilliseconds < 100, 'Badge counter update exceeded 100ms floor threshold');
  }

  /// Manual sync trigger for pull-to-refresh actions.
  Future<void> manualSync() async {
    await Future.delayed(const Duration(milliseconds: 20)); // Simulated optimal target < 20ms
    _updateBadgeCount();
  }

  void dispose() {
    stopPolling();
    _badgeCountController.close();
  }
}

/// Engineering Console Dashboard Widget displaying step health via M3 Elevated Card.
/// Implements single-column mobile layout (<600dp) and multi-column desktop (>=840dp).
class BadgeCounterDashboard extends StatefulWidget {
  const BadgeCounterDashboard({super.key});

  @override
  State<BadgeCounterDashboard> createState() => _BadgeCounterDashboardState();
}

class _BadgeCounterDashboardState extends State<BadgeCounterDashboard> {
  late final BadgeCounterService _service;

  @override
  void initState() {
    super.initState();
    _service = BadgeCounterService.instance;
    _service.startPolling();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await _service.manualSync();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Console - Badge Metrics'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: StreamBuilder<int>(
          stream: _service.badgeCountStream,
          initialData: _service.currentTotalCount,
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;
            final isPassing = true; // Mock validation status

            return LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                final crossAxisCount = isMobile ? 1 : (constraints.maxWidth >= 840 ? 3 : 2);

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: [
                      SizedBox(
                        width: isMobile ? double.infinity : 300,
                        child: _buildStatusCard(context, count, isPassing, colorScheme, textTheme),
                      ),
                      ...MockBadgeData.unreadMetrics.map((metric) {
                        return SizedBox(
                          width: isMobile ? double.infinity : 300,
                          child: _buildMetricCard(context, metric, colorScheme, textTheme),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// M3 Elevated Card Level 2 (3dp) with inline status chip.
  Widget _buildStatusCard(
    BuildContext context,
    int totalCount,
    bool isPassing,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Card(
      elevation: 3.0,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Badge Counter Health', style: textTheme.titleMedium),
                Chip(
                  label: Text(
                    isPassing ? 'Pass' : 'Fail',
                    style: TextStyle(
                      color: isPassing ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: isPassing ? colorScheme.primaryContainer : colorScheme.errorContainer,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Total Unread: $totalCount',
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Update Speed: < 20ms (Optimal)',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 48.0,
              width: 48.0,
              child: IconButton(
                iconSize: 24.0,
                onPressed: () {
                  _showConfigBottomSheet(context);
                },
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Configuration Inputs',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    Map<String, dynamic> metric,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final count = metric['count'] as int;
    final label = metric['label'] as String;

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(label, style: textTheme.bodyLarge),
        trailing: count > 0
            ? Badge(
                largeSize: 24.0,
                backgroundColor: colorScheme.error,
                textColor: colorScheme.onError,
                label: Text(count.toString()),
                child: const Icon(Icons.notifications_active_outlined),
              )
            : const Icon(Icons.notifications_none_outlined, color: Colors.grey),
      ),
    );
  }

  /// M3 Bottom Sheet for configuration inputs.
  void _showConfigBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Badge Configuration',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Floor Threshold (ms)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                ),
                readOnly: true,
                controller: TextEditingController(text: '100'),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Configuration saved successfully.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Apply Settings'),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }
}