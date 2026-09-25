// GEN-02670 — Runbook Dashboard Configuration Card.
// Displays dashboard configuration, metric sources, and color coding rules using M3 Elevated Cards with status chips. Single-column mobile layout (<600dp), multi-column desktop (>=840dp). Background polling every 30 seconds with pull-to-refresh support.

import 'dart:async';
import 'package:flutter/material.dart';

enum DocumentationStatus { complete, partial, notComplete }

class RunbookMetric {
  final String name;
  final String source;
  final DocumentationStatus status;
  final String floorBoundary;
  final String optimalTarget;

  const RunbookMetric({
    required this.name,
    required this.source,
    required this.status,
    required this.floorBoundary,
    required this.optimalTarget,
  });
}

class MockRunbookRepository {
  static const List<RunbookMetric> metrics = [
    RunbookMetric(
      name: 'Runbook Documentation Completeness',
      source: 'ITIL v4 — Knowledge Management Documentation Standards',
      status: DocumentationStatus.complete,
      floorBoundary: 'All required sections documented',
      optimalTarget: '100% complete documentation with tested procedures',
    ),
    RunbookMetric(
      name: 'Dashboard Configuration Validation',
      source: 'Internal Engineering Console',
      status: DocumentationStatus.partial,
      floorBoundary: 'Core widgets configured',
      optimalTarget: 'All panels validated against design tokens',
    ),
    RunbookMetric(
      name: 'Color Coding Rules Compliance',
      source: 'Material Design 3 Dynamic Color Spec',
      status: DocumentationStatus.notComplete,
      floorBoundary: 'Base palette defined',
      optimalTarget: 'Full semantic color mapping applied',
    ),
  ];

  Future<List<RunbookMetric>> fetchMetrics() async {
    await Future.delayed(const Duration(milliseconds: 80));
    return metrics;
  }
}

class RunbookDashboardCardGen02670 extends StatefulWidget {
  const RunbookDashboardCardGen02670({super.key});

  @override
  State<RunbookDashboardCardGen02670> createState() => _RunbookDashboardCardGen02670State();
}

class _RunbookDashboardCardGen02670State extends State<RunbookDashboardCardGen02670> {
  final MockRunbookRepository _repository = MockRunbookRepository();
  List<RunbookMetric> _metrics = [];
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
    setState(() => _isLoading = true);
    final data = await _repository.fetchMetrics();
    if (mounted) {
      setState(() {
        _metrics = data;
        _isLoading = false;
      });
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadData();
    });
  }

  Color _getStatusColor(DocumentationStatus status, ColorScheme colorScheme) {
    switch (status) {
      case DocumentationStatus.complete:
        return colorScheme.primary;
      case DocumentationStatus.partial:
        return colorScheme.tertiary;
      case DocumentationStatus.notComplete:
        return colorScheme.error;
    }
  }

  String _getStatusLabel(DocumentationStatus status) {
    switch (status) {
      case DocumentationStatus.complete:
        return 'Complete';
      case DocumentationStatus.partial:
        return 'Partial';
      case DocumentationStatus.notComplete:
        return 'Not Complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 840;
          final crossAxisCount = isDesktop ? 2 : 1;

          if (_isLoading && _metrics.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Engineering Runbook Dashboard',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Configuration, Metric Sources & Color Coding Rules',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: isDesktop ? 2.5 : 1.8,
                  ),
                  itemCount: _metrics.length,
                  itemBuilder: (context, index) {
                    final metric = _metrics[index];
                    return _buildMetricCard(metric, theme, colorScheme);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(RunbookMetric metric, ThemeData theme, ColorScheme colorScheme) {
    final statusColor = _getStatusColor(metric.status, colorScheme);

    return Card(
      elevation: 3.0,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () => _showDetailSheet(metric, theme),
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      metric.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      _getStatusLabel(metric.status),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: statusColor.withOpacity(0.12),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Source: ${metric.source}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Floor: ${metric.floorBoundary}',
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Target: ${metric.optimalTarget}',
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailSheet(RunbookMetric metric, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    metric.name,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Status', _getStatusLabel(metric.status), theme),
                  _buildDetailRow('Source', metric.source, theme),
                  _buildDetailRow('Floor Boundary', metric.floorBoundary, theme),
                  _buildDetailRow('Optimal Target', metric.optimalTarget, theme),
                  _buildDetailRow('Standard', 'ITIL v4 — Knowledge Management', theme),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Deep-link drill-down initiated for ${metric.name}'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open Drill-Down View'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
