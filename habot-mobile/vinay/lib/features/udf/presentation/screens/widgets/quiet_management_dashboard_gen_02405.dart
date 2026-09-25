// GEN-02405 — Quiet Management Admin Dashboard with M3 Status Cards.
// Implements a read-only engineering console dashboard displaying system health metrics for 6 core modules using Material 3 Elevated Cards, status chips, and responsive single/multi-column layouts.

import 'package:flutter/material.dart';

enum SystemHealthStatus { realTime, nearRealTime, delayed, failure }

class ModuleHealthMetric {
  final String moduleName;
  final double dataFreshnessMinutes;
  final SystemHealthStatus status;
  final int floorBoundary;
  final int ceilingBoundary;

  const ModuleHealthMetric({
    required this.moduleName,
    required this.dataFreshnessMinutes,
    required this.status,
    this.floorBoundary = 5,
    this.ceilingBoundary = 1,
  });
}

const List<ModuleHealthMetric> kMockModuleMetrics = [
  ModuleHealthMetric(moduleName: 'Auth Module', dataFreshnessMinutes: 0.5, status: SystemHealthStatus.realTime),
  ModuleHealthMetric(moduleName: 'UDF Engine', dataFreshnessMinutes: 0.8, status: SystemHealthStatus.nearRealTime),
  ModuleHealthMetric(moduleName: 'Telemetry', dataFreshnessMinutes: 1.2, status: SystemHealthStatus.nearRealTime),
  ModuleHealthMetric(moduleName: 'Security', dataFreshnessMinutes: 0.2, status: SystemHealthStatus.realTime),
  ModuleHealthMetric(moduleName: 'Network', dataFreshnessMinutes: 6.5, status: SystemHealthStatus.delayed),
  ModuleHealthMetric(moduleName: 'Workflow', dataFreshnessMinutes: 0.9, status: SystemHealthStatus.nearRealTime),
];

class QuietManagementDashboardGen02405 extends StatefulWidget {
  const QuietManagementDashboardGen02405({super.key});

  @override
  State<QuietManagementDashboardGen02405> createState() => _QuietManagementDashboardGen02405State();
}

class _QuietManagementDashboardGen02405State extends State<QuietManagementDashboardGen02405> {
  late List<ModuleHealthMetric> _metrics;

  @override
  void initState() {
    super.initState();
    _metrics = kMockModuleMetrics;
  }

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _metrics = kMockModuleMetrics.map((m) {
        final fresh = m.dataFreshnessMinutes + 0.1;
        SystemHealthStatus newStatus = m.status;
        if (fresh <= 1) newStatus = SystemHealthStatus.realTime;
        else if (fresh <= 5) newStatus = SystemHealthStatus.nearRealTime;
        else newStatus = SystemHealthStatus.delayed;
        return ModuleHealthMetric(
          moduleName: m.moduleName,
          dataFreshnessMinutes: double.parse(fresh.toStringAsFixed(1)),
          status: newStatus,
          floorBoundary: m.floorBoundary,
          ceilingBoundary: m.ceilingBoundary,
        );
      }).toList();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('System metrics synchronized successfully.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiet Management Console'),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        edgeOffset: 48.0,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isMobile = constraints.maxWidth < 600;
            final int crossAxisCount = isMobile ? 1 : (constraints.maxWidth >= 840 ? 3 : 2);

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: isMobile ? 2.8 : 2.2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final metric = _metrics[index];
                        return _HealthMetricCard(metric: metric);
                      },
                      childCount: _metrics.length,
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
}

class _HealthMetricCard extends StatelessWidget {
  final ModuleHealthMetric metric;

  const _HealthMetricCard({required this.metric});

  Color _getStatusColor(SystemHealthStatus status, ThemeData theme) {
    switch (status) {
      case SystemHealthStatus.realTime:
        return theme.colorScheme.primary;
      case SystemHealthStatus.nearRealTime:
        return theme.colorScheme.secondary;
      case SystemHealthStatus.delayed:
        return theme.colorScheme.tertiary;
      case SystemHealthStatus.failure:
        return theme.colorScheme.error;
    }
  }

  String _getStatusLabel(SystemHealthStatus status) {
    switch (status) {
      case SystemHealthStatus.realTime:
        return 'Real-time';
      case SystemHealthStatus.nearRealTime:
        return 'Near Real-time';
      case SystemHealthStatus.delayed:
        return 'Delayed';
      case SystemHealthStatus.failure:
        return 'Failure';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color statusColor = _getStatusColor(metric.status, theme);

    return Semantics(
      label: '${metric.moduleName} health status: ${_getStatusLabel(metric.status)}, data freshness: ${metric.dataFreshnessMinutes} minutes',
      button: true,
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              useSafeArea: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
              ),
              builder: (BuildContext ctx) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(metric.moduleName, style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      Text('Data Freshness: ${metric.dataFreshnessMinutes} min', style: theme.textTheme.bodyLarge),
                      Text('Floor Boundary: ${metric.floorBoundary} min', style: theme.textTheme.bodyMedium),
                      Text('Ceiling Boundary: ${metric.ceilingBoundary} min', style: theme.textTheme.bodyMedium),
                      Text('Status: ${_getStatusLabel(metric.status)}', style: theme.textTheme.bodyMedium?.copyWith(color: statusColor)),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48.0,
                        child: FilledButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Close Details'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        metric.moduleName,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Chip(
                      avatar: Icon(Icons.circle, size: 12, color: statusColor),
                      label: Text(_getStatusLabel(metric.status), style: TextStyle(fontSize: 12, color: statusColor)),
                      backgroundColor: statusColor.withOpacity(0.12),
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 18, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text(
                      '${metric.dataFreshnessMinutes} min freshness',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}