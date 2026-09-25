// GEN-02637 — Bottleneck Highlighter Dashboard Widget.
// Integrates bottleneck highlighters directly into dashboard views using M3 Elevated Cards, status chips, and responsive single/multi-column layouts with 30-second background polling.

import 'dart:async';
import 'package:flutter/material.dart';

enum DataFreshnessStatus { realTime, nearRealTime, delayed }

class BottleneckMetric {
  final String id;
  final String name;
  final double freshnessMinutes;
  final DataFreshnessStatus status;
  final String traceId;
  final DateTime timestamp;

  const BottleneckMetric({
    required this.id,
    required this.name,
    required this.freshnessMinutes,
    required this.status,
    required this.traceId,
    required this.timestamp,
  });
}

class MockBottleneckRepository {
  static List<BottleneckMetric> fetchMetrics() {
    return [
      BottleneckMetric(
        id: 'BN-001',
        name: 'API Gateway Latency',
        freshnessMinutes: 0.5,
        status: DataFreshnessStatus.realTime,
        traceId: 'trace_abc_123',
        timestamp: DateTime.now(),
      ),
      BottleneckMetric(
        id: 'BN-002',
        name: 'Database Query Queue',
        freshnessMinutes: 3.2,
        status: DataFreshnessStatus.nearRealTime,
        traceId: 'trace_def_456',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      BottleneckMetric(
        id: 'BN-003',
        name: 'Auth Service Bottleneck',
        freshnessMinutes: 8.5,
        status: DataFreshnessStatus.delayed,
        traceId: 'trace_ghi_789',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
    ];
  }
}

class BottleneckHighlighterDashboard extends StatefulWidget {
  const BottleneckHighlighterDashboard({super.key});

  @override
  State<BottleneckHighlighterDashboard> createState() => _BottleneckHighlighterDashboardState();
}

class _BottleneckHighlighterDashboardState extends State<BottleneckHighlighterDashboard> {
  List<BottleneckMetric> _metrics = [];
  Timer? _pollingTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) => _loadMetrics());
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadMetrics() async {
    if (!mounted) return;
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      _metrics = MockBottleneckRepository.fetchMetrics();
      _isRefreshing = false;
    });
  }

  Color _getStatusColor(DataFreshnessStatus status, ThemeData theme) {
    switch (status) {
      case DataFreshnessStatus.realTime:
        return theme.colorScheme.primary;
      case DataFreshnessStatus.nearRealTime:
        return theme.colorScheme.tertiary;
      case DataFreshnessStatus.delayed:
        return theme.colorScheme.error;
    }
  }

  String _getStatusLabel(DataFreshnessStatus status) {
    switch (status) {
      case DataFreshnessStatus.realTime:
        return 'Real-time';
      case DataFreshnessStatus.nearRealTime:
        return 'Near Real-time';
      case DataFreshnessStatus.delayed:
        return 'Delayed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final crossAxisCount = isMobile ? 1 : (screenWidth >= 840 ? 3 : 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottleneck Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _loadMetrics,
            tooltip: 'Manual Sync',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadMetrics,
        child: _metrics.isEmpty && !_isRefreshing
            ? const Center(child: Text('No bottleneck data available.'))
            : GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: isMobile ? 2.2 : 1.8,
                ),
                itemCount: _metrics.length,
                itemBuilder: (context, index) {
                  final metric = _metrics[index];
                  return _buildElevatedCard(metric, theme);
                },
              ),
      ),
    );
  }

  Widget _buildElevatedCard(BottleneckMetric metric, ThemeData theme) {
    final statusColor = _getStatusColor(metric.status, theme);

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetailsBottomSheet(metric, theme),
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
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      _getStatusLabel(metric.status),
                      style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: statusColor.withOpacity(0.12),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Freshness: ${metric.freshnessMinutes.toStringAsFixed(1)} min',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 4),
              Text(
                'Trace ID: ${metric.traceId}',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsBottomSheet(BottleneckMetric metric, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bottleneck Details', style: theme.textTheme.headlineSmall),
              const Divider(height: 24),
              _detailRow('Name', metric.name, theme),
              _detailRow('Status', _getStatusLabel(metric.status), theme),
              _detailRow('Data Freshness', '${metric.freshnessMinutes} minutes', theme),
              _detailRow('Trace ID', metric.traceId, theme),
              _detailRow('Timestamp', metric.timestamp.toIso8601String(), theme),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Drill-down initiated for ${metric.name}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Deep-link Drill-down'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}