// GEN-03033 — SIEM Log Ingestion Status Monitor.
// Displays a read-only M3 status monitor for SIEM log ingestion health in the mobile security console, featuring Elevated Cards, Status Chips, and 30-second polling with pull-to-refresh.

import 'dart:async';
import 'package:flutter/material.dart';

/// Mock data representing SIEM log ingestion metrics aligned with SRE Golden Signals.
class SiemIngestionMetrics {
  final String alertDetectionTimeMetric;
  final double detectionTimeSeconds;
  final String completionStatus;
  final DateTime lastUpdated;
  final String traceId;

  const SiemIngestionMetrics({
    required this.alertDetectionTimeMetric,
    required this.detectionTimeSeconds,
    required this.completionStatus,
    required this.lastUpdated,
    required this.traceId,
  });
}

/// Mock repository providing realistic local data for the SIEM monitor.
class MockSiemRepository {
  static Future<SiemIngestionMetrics> fetchMetrics() async {
    await Future.delayed(const Duration(milliseconds: 80)); // Sub-100ms mock latency
    return SiemIngestionMetrics(
      alertDetectionTimeMetric: 'Observability Alert Detection Time (s)',
      detectionTimeSeconds: 12.5,
      completionStatus: 'Pass',
      lastUpdated: DateTime.now(),
      traceId: 'trace-gen-03033-${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

class SiemLogIngestionStatusMonitorGen03033 extends StatefulWidget {
  const SiemLogIngestionStatusMonitorGen03033({super.key});

  @override
  State<SiemLogIngestionStatusMonitorGen03033> createState() => _SiemLogIngestionStatusMonitorGen03033State();
}

class _SiemLogIngestionStatusMonitorGen03033State extends State<SiemLogIngestionStatusMonitorGen03033> {
  SiemIngestionMetrics? _metrics;
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Background polling refreshes data every 30 seconds.
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) => _loadData());
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final data = await MockSiemRepository.fetchMetrics();
      if (mounted) {
        setState(() {
          _metrics = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _getStatusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status.toLowerCase()) {
      case 'pass':
        return colorScheme.primary;
      case 'fail':
        return colorScheme.error;
      default:
        return colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // M3 responsive layout: single-column on mobile (<600dp), multi-column on desktop (>=840dp).
          final isDesktop = constraints.maxWidth >= 840;
          final crossAxisCount = isDesktop ? 2 : 1;

          if (_isLoading && _metrics == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.count(
            padding: const EdgeInsets.all(16.0),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: isDesktop ? 2.5 : 3.0,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _buildStatusCard(context, colorScheme, textTheme),
              _buildMetricCard(context, colorScheme, textTheme),
            ],
          );
        },
      ),
    );
  }

  /// M3 Elevated Cards Level 2 (3dp) with M3 Status Chips for health indicators.
  Widget _buildStatusCard(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    final status = _metrics?.completionStatus ?? 'Unknown';
    final statusColor = _getStatusColor(context, status);

    return Card(
      elevation: 3.0,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SIEM Log Ingestion Status',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Completion State',
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
                // M3 Status Chip
                Chip(
                  label: Text(
                    status,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: statusColor.withOpacity(0.12),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Trace ID: ${_metrics?.traceId ?? 'N/A'}',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    final detectionTime = _metrics?.detectionTimeSeconds ?? 0.0;
    // Floor threshold: 30.0, Optimal Target: 10, Ceiling Boundary: 60
    final isWithinFloor = detectionTime <= 30.0;
    final metricColor = isWithinFloor ? colorScheme.primary : colorScheme.error;

    return Card(
      elevation: 3.0,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _metrics?.alertDetectionTimeMetric ?? 'Observability Alert Detection Time (s)',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${detectionTime.toStringAsFixed(1)}s',
                  style: textTheme.headlineMedium?.copyWith(
                    color: metricColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Text(
                    isWithinFloor ? '(Optimal)' : '(Degraded)',
                    style: textTheme.bodySmall?.copyWith(color: metricColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Last Updated: ${_metrics?.lastUpdated.toString().substring(0, 19) ?? 'N/A'}',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
            // 48x48dp touch target for deep-link drill-down
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: IconButton(
                  icon: Icon(Icons.open_in_new, color: colorScheme.primary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      // M3 Snackbar for confirmations
                      SnackBar(
                        content: const Text('Drill-down initiated for detailed logs.'),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'DISMISS',
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  tooltip: 'View Details',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}