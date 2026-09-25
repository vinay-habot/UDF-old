// GEN-02483 — Appreciation and Pebble Scheme (APS) Tracker Card.
// Displays atomic actions contributing to APS points using M3 Elevated Cards, status chips, and responsive single/multi-column layout with 30s polling and pull-to-refresh.

import 'dart:async';
import 'package:flutter/material.dart';

enum ApsCompletionStatus { complete, partial, notComplete }

class ApsAtomicAction {
  final String id;
  final String traceId;
  final String title;
  final String description;
  final ApsCompletionStatus status;
  final double processCompletionRate;
  final DateTime timestamp;

  const ApsAtomicAction({
    required this.id,
    required this.traceId,
    required this.title,
    required this.description,
    required this.status,
    required this.processCompletionRate,
    required this.timestamp,
  });
}

class MockApsRepository {
  static const List<ApsAtomicAction> mockActions = [
    ApsAtomicAction(
      id: 'ACT-001',
      traceId: 'trace-9a8b7c6d',
      title: 'Initialize DCDF Engine Baseline',
      description: 'Identify the atomic actions that directly contribute to APS points.',
      status: ApsCompletionStatus.complete,
      processCompletionRate: 1.0,
      timestamp: DateTime(2026, 9, 25, 10, 0),
    ),
    ApsAtomicAction(
      id: 'ACT-002',
      traceId: 'trace-1f2e3d4c',
      title: 'Configure BigQuery Streaming',
      description: 'Stream step execution events partitioned by event_date, clustered by trace_id.',
      status: ApsCompletionStatus.partial,
      processCompletionRate: 0.65,
      timestamp: DateTime(2026, 9, 25, 10, 15),
    ),
    ApsAtomicAction(
      id: 'ACT-003',
      traceId: 'trace-5b6a7c8d',
      title: 'Validate ISO/IEC 25010 Compliance',
      description: 'Ensure product quality metrics meet floor threshold of 0% and optimal target of 95-100%.',
      status: ApsCompletionStatus.notComplete,
      processCompletionRate: 0.0,
      timestamp: DateTime(2026, 9, 25, 10, 30),
    ),
  ];

  Future<List<ApsAtomicAction>> fetchActions() async {
    await Future.delayed(const Duration(milliseconds: 80)); // Simulate sub-100ms latency
    return mockActions;
  }
}

class ApsTrackerCard extends StatefulWidget {
  const ApsTrackerCard({super.key});

  @override
  State<ApsTrackerCard> createState() => _ApsTrackerCardState();
}

class _ApsTrackerCardState extends State<ApsTrackerCard> {
  final MockApsRepository _repository = MockApsRepository();
  List<ApsAtomicAction> _actions = [];
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final data = await _repository.fetchActions();
    if (!mounted) return;
    setState(() {
      _actions = data;
      _isLoading = false;
    });
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadData();
    });
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  Color _getStatusColor(ApsCompletionStatus status, ColorScheme colorScheme) {
    switch (status) {
      case ApsCompletionStatus.complete:
        return colorScheme.primary;
      case ApsCompletionStatus.partial:
        return colorScheme.tertiary;
      case ApsCompletionStatus.notComplete:
        return colorScheme.error;
    }
  }

  String _getStatusLabel(ApsCompletionStatus status) {
    switch (status) {
      case ApsCompletionStatus.complete:
        return 'Complete';
      case ApsCompletionStatus.partial:
        return 'Partial';
      case ApsCompletionStatus.notComplete:
        return 'Not Complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('APS Tracker'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: colorScheme.primary,
        child: _isLoading && _actions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 600;
                  final isTabletOrDesktop = constraints.maxWidth >= 840;

                  if (isMobile) {
                    return _buildListView(_actions, theme, colorScheme, isMobile: true);
                  } else if (isTabletOrDesktop) {
                    return _buildGridView(_actions, theme, colorScheme);
                  } else {
                    return _buildListView(_actions, theme, colorScheme, isMobile: false);
                  }
                },
              ),
      ),
    );
  }

  Widget _buildListView(List<ApsAtomicAction> actions, ThemeData theme, ColorScheme colorScheme, {required bool isMobile}) {
    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildActionCard(actions[index], theme, colorScheme),
        );
      },
    );
  }

  Widget _buildGridView(List<ApsAtomicAction> actions, ThemeData theme, ColorScheme colorScheme) {
    return GridView.builder(
      padding: const EdgeInsets.all(24.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 1.2,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return _buildActionCard(actions[index], theme, colorScheme);
      },
    );
  }

  Widget _buildActionCard(ApsAtomicAction action, ThemeData theme, ColorScheme colorScheme) {
    final statusColor = _getStatusColor(action.status, colorScheme);

    return Card(
      elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showConfigurationSheet(context, action, theme, colorScheme),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      action.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Chip(
                    label: Text(
                      _getStatusLabel(action.status),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: statusColor.withOpacity(0.12),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                action.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: action.processCompletionRate.clamp(0.0, 1.0),
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 6.0,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    '${(action.processCompletionRate * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trace: ${action.traceId}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    'ISO/IEC 25010',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
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

  void _showConfigurationSheet(
    BuildContext context,
    ApsAtomicAction action,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24.0,
            right: 24.0,
            top: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 32.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                'Configuration Details',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16.0),
              _buildDetailRow('Action ID', action.id, theme, colorScheme),
              _buildDetailRow('Trace ID', action.traceId, theme, colorScheme),
              _buildDetailRow('Status', _getStatusLabel(action.status), theme, colorScheme),
              _buildDetailRow('Process Completion Rate', '${(action.processCompletionRate * 100).toStringAsFixed(1)}%', theme, colorScheme),
              _buildDetailRow('Timestamp', action.timestamp.toIso8601String(), theme, colorScheme),
              _buildDetailRow('Standard', 'ISO/IEC 25010 (Product Quality)', theme, colorScheme),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 48.0, // 48x48dp touch targets
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Configuration viewed for ${action.id}'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        backgroundColor: colorScheme.inverseSurface,
                        contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
                      ),
                    );
                  },
                  child: const Text('Acknowledge & Close'),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160.0,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
