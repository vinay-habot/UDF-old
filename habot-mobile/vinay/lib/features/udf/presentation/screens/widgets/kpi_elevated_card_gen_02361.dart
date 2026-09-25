// GEN-02361 — M3 Elevated KPI Card with subtle elevation for displaying Key Performance Indicators.
// Implements Material Design 3 Level 2 elevation (3dp), status chips, responsive single/multi-column layout, and mock data polling.

import 'dart:async';
import 'package:flutter/material.dart';

/// Mock data model representing a KPI metric.
class KpiMetric {
  final String id;
  final String title;
  final double value;
  final double floorThreshold;
  final String unit;
  final DateTime lastUpdated;

  const KpiMetric({
    required this.id,
    required this.title,
    required this.value,
    required this.floorThreshold,
    required this.unit,
    required this.lastUpdated,
  });

  bool get isPassing => value >= floorThreshold;
}

/// Mock repository simulating backend data fetch.
class MockKpiRepository {
  static List<KpiMetric> fetchKpis() {
    return [
      KpiMetric(
        id: 'kpi_001',
        title: 'UI Compliance Rate',
        value: 0.98,
        floorThreshold: 0.95,
        unit: '%',
        lastUpdated: DateTime.now(),
      ),
      KpiMetric(
        id: 'kpi_002',
        title: 'API Latency',
        value: 85.0,
        floorThreshold: 100.0,
        unit: 'ms',
        lastUpdated: DateTime.now(),
      ),
      KpiMetric(
        id: 'kpi_003',
        title: 'CI/CD Pass Rate',
        value: 1.0,
        floorThreshold: 1.0,
        unit: '%',
        lastUpdated: DateTime.now(),
      ),
      KpiMetric(
        id: 'kpi_004',
        title: 'Error Rate',
        value: 0.02,
        floorThreshold: 0.05,
        unit: '%',
        lastUpdated: DateTime.now(),
      ),
    ];
  }
}

/// Responsive KPI Dashboard Screen implementing M3 Elevated Cards.
class KpiDashboardScreenGen02361 extends StatefulWidget {
  const KpiDashboardScreenGen02361({super.key});

  @override
  State<KpiDashboardScreenGen02361> createState() => _KpiDashboardScreenGen02361State();
}

class _KpiDashboardScreenGen02361State extends State<KpiDashboardScreenGen02361> {
  List<KpiMetric> _metrics = [];
  Timer? _pollingTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
    // Background polling refreshes data every 30 seconds.
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadMetrics();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadMetrics() async {
    if (!mounted) return;
    setState(() {
      _metrics = MockKpiRepository.fetchKpis();
    });
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
    await _loadMetrics();
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data synchronized successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  int _calculateCrossAxisCount(double width) {
    // M3 responsive layout: single-column on mobile (<600dp), multi-column on desktop (>=840dp)
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Console - KPIs'),
        centerTitle: false,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: crossAxisCount == 1 ? 3.0 : 1.8,
              ),
              itemCount: _metrics.length,
              itemBuilder: (context, index) {
                final metric = _metrics[index];
                return KpiElevatedCardGen02361(metric: metric);
              },
            );
          },
        ),
      ),
    );
  }
}

/// M3 Elevated Card Level 2 (3dp) with Status Chip.
class KpiElevatedCardGen02361 extends StatelessWidget {
  final KpiMetric metric;

  const KpiElevatedCardGen02361({
    super.key,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPassing = metric.isPassing;

    return Semantics(
      label: '${metric.title}: ${metric.value} ${metric.unit}. Status: ${isPassing ? "Pass" : "Fail"}',
      button: true,
      child: Card(
        // M3 Elevated Cards Level 2 (3dp)
        elevation: 3.0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: colorScheme.surfaceContainerLow,
        child: InkWell(
          // 48x48dp touch targets guaranteed by card size
          onTap: () => _showDetailsBottomSheet(context, metric),
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
                        metric.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // M3 Status Chips for health indicators
                    _buildStatusChip(context, isPassing),
                  ],
                ),
                const Spacer(),
                Text(
                  metric.unit == '%' && metric.value <= 1.0
                      ? '${(metric.value * 100).toStringAsFixed(1)}${metric.unit}'
                      : '${metric.value.toStringAsFixed(metric.value % 1 == 0 ? 0 : 1)} ${metric.unit}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: isPassing ? colorScheme.primary : colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Floor: ${metric.unit == '%' && metric.floorThreshold <= 1.0 ? '${(metric.floorThreshold * 100).toStringAsFixed(0)}%' : metric.floorThreshold.toStringAsFixed(1)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, bool isPassing) {
    return Chip(
      avatar: Icon(
        isPassing ? Icons.check_circle_outline : Icons.error_outline,
        size: 16,
        color: isPassing
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
      ),
      label: Text(
        isPassing ? 'Pass' : 'Fail',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      backgroundColor: isPassing
          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
          : Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  /// M3 Bottom Sheet for configuration inputs / deep-link drill-down.
  void _showDetailsBottomSheet(BuildContext context, KpiMetric metric) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.analytics_outlined),
                title: const Text('Current Value'),
                subtitle: Text(metric.value.toString()),
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Floor Threshold'),
                subtitle: Text(metric.floorThreshold.toString()),
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text('Last Updated'),
                subtitle: Text(metric.lastUpdated.toIso8601String()),
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                leading: Icon(
                  metric.isPassing ? Icons.verified : Icons.warning,
                  color: metric.isPassing
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
                title: const Text('Compliance Status'),
                subtitle: Text(metric.isPassing ? 'Passing (WCAG 2.2 AA)' : 'Failing'),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48, // 48x48dp touch target
                child: FilledButton.tonal(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close Details'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
