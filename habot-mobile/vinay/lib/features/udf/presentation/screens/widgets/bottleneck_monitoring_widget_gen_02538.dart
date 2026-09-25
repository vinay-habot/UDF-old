// GEN-02538 — Bottleneck Monitoring Widget for Mobile Admin Dashboard.
// M3 Elevated Card displaying RBAC Enforcement Rate with status chips, 30s polling, and pull-to-refresh support.

import 'dart:async';
import 'package:flutter/material.dart';

enum RbacStatus { pass, fail }

class RbacMetricData {
  final String metricName;
  final double currentRate;
  final double floorThreshold;
  final RbacStatus status;
  final DateTime timestamp;
  final String traceId;

  const RbacMetricData({
    required this.metricName,
    required this.currentRate,
    required this.floorThreshold,
    required this.status,
    required this.timestamp,
    required this.traceId,
  });
}

class MockBottleneckRepository {
  static const List<RbacMetricData> _mockData = [
    RbacMetricData(
      metricName: 'RBAC Enforcement Rate (%)',
      currentRate: 0.9995,
      floorThreshold: 0.999,
      status: RbacStatus.pass,
      timestamp: null as dynamic,
      traceId: 'trace-001-gen-02538',
    ),
    RbacMetricData(
      metricName: 'RBAC Enforcement Rate (%)',
      currentRate: 0.9982,
      floorThreshold: 0.999,
      status: RbacStatus.fail,
      timestamp: null as dynamic,
      traceId: 'trace-002-gen-02538',
    ),
  ];

  static int _index = 0;

  static Future<RbacMetricData> fetchLatestMetric() async {
    await Future.delayed(const Duration(milliseconds: 80));
    final data = _mockData[_index % _mockData.length];
    _index++;
    return RbacMetricData(
      metricName: data.metricName,
      currentRate: data.currentRate,
      floorThreshold: data.floorThreshold,
      status: data.status,
      timestamp: DateTime.now(),
      traceId: data.traceId,
    );
  }
}

class BottleneckMonitoringWidget extends StatefulWidget {
  const BottleneckMonitoringWidget({super.key});

  @override
  State<BottleneckMonitoringWidget> createState() => _BottleneckMonitoringWidgetState();
}

class _BottleneckMonitoringWidgetState extends State<BottleneckMonitoringWidget> {
  RbacMetricData? _metricData;
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
    try {
      final data = await MockBottleneckRepository.fetchLatestMetric();
      if (mounted) {
        setState(() {
          _metricData = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) => _loadData());
  }

  Future<void> _onRefresh() async {
    await _loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Bottleneck metrics synchronized'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isMobile ? _buildSingleColumn(theme) : _buildMultiColumn(theme),
        ),
      ),
    );
  }

  Widget _buildSingleColumn(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_buildMetricCard(theme)],
    );
  }

  Widget _buildMultiColumn(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildMetricCard(theme)),
        const SizedBox(width: 16),
        Expanded(child: _buildDetailsPanel(theme)),
      ],
    );
  }

  Widget _buildMetricCard(ThemeData theme) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bottleneck Monitor',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                _buildStatusChip(theme),
              ],
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_metricData != null)
              ...[
                Text(
                  _metricData!.metricName,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(_metricData!.currentRate * 100).toStringAsFixed(2)}%',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _metricData!.status == RbacStatus.pass
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Floor Threshold: ${(_metricData!.floorThreshold * 100).toStringAsFixed(1)}%',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                ),
                const SizedBox(height: 16),
                Text(
                  'Last Updated: ${_formatTimestamp(_metricData!.timestamp)}',
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
                ),
              ]
            else
              Text('No data available', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              width: 48,
              child: IconButton(
                onPressed: () => _showConfigBottomSheet(theme),
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Configuration',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsPanel(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step Details', style: theme.textTheme.titleMedium),
            const Divider(),
            _buildDetailRow(theme, 'Trace ID', _metricData?.traceId ?? 'N/A'),
            _buildDetailRow(theme, 'Standard', 'ISO/IEC 27001, NIST CSF'),
            _buildDetailRow(theme, 'Output', _metricData?.status.name.toUpperCase() ?? 'N/A'),
            _buildDetailRow(theme, 'Step ID', 'GEN-02538'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    if (_isLoading || _metricData == null) {
      return Chip(
        label: const Text('LOADING'),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        labelStyle: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
      );
    }
    final isPass = _metricData!.status == RbacStatus.pass;
    return Chip(
      avatar: Icon(isPass ? Icons.check_circle : Icons.error, size: 16, color: isPass ? Colors.green : theme.colorScheme.error),
      label: Text(isPass ? 'PASS' : 'FAIL'),
      backgroundColor: isPass ? theme.colorScheme.primaryContainer : theme.colorScheme.errorContainer,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: isPass ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onErrorContainer,
      ),
    );
  }

  void _showConfigBottomSheet(ThemeData theme) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Widget Configuration', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Enable Auto-Polling (30s)'),
                value: _pollingTimer?.isActive ?? false,
                onChanged: (val) {
                  Navigator.pop(context);
                  if (val) {
                    _startPolling();
                  } else {
                    _pollingTimer?.cancel();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(val ? 'Polling enabled' : 'Polling disabled')),
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime? dt) {
    if (dt == null) return 'N/A';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }
}