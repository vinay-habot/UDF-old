// GEN-02692 — Infrastructure SLA Timer M3 Elevated Card Widget.
// Displays Service Uptime Rate with Good/Average/Poor status chips, 30s background polling, and responsive single/multi-column layout.

import 'dart:async';
import 'package:flutter/material.dart';

enum SlaStatus { good, average, poor }

class SlaMetricData {
  final String metricName;
  final double uptimeRate;
  final SlaStatus status;
  final DateTime lastUpdated;

  const SlaMetricData({
    required this.metricName,
    required this.uptimeRate,
    required this.status,
    required this.lastUpdated,
  });
}

class MockSlaRepository {
  static Future<SlaMetricData> fetchSlaMetrics() async {
    await Future.delayed(const Duration(milliseconds: 80));
    return SlaMetricData(
      metricName: 'Service Uptime Rate',
      uptimeRate: 99.95,
      status: SlaStatus.good,
      lastUpdated: DateTime.now(),
    );
  }
}

class SlaTimerCardGen02692 extends StatefulWidget {
  const SlaTimerCardGen02692({super.key});

  @override
  State<SlaTimerCardGen02692> createState() => _SlaTimerCardGen02692State();
}

class _SlaTimerCardGen02692State extends State<SlaTimerCardGen02692> {
  SlaMetricData? _metricData;
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchData());
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final data = await MockSlaRepository.fetchSlaMetrics();
      if (mounted) {
        setState(() {
          _metricData = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _metricData = SlaMetricData(
            metricName: 'Service Uptime Rate',
            uptimeRate: 0.0,
            status: SlaStatus.poor,
            lastUpdated: DateTime.now(),
          );
          _isLoading = false;
        });
      }
    }
  }

  Color _getStatusColor(SlaStatus status, ThemeData theme) {
    switch (status) {
      case SlaStatus.good:
        return theme.colorScheme.primary;
      case SlaStatus.average:
        return theme.colorScheme.tertiary;
      case SlaStatus.poor:
        return theme.colorScheme.error;
    }
  }

  String _getStatusLabel(SlaStatus status) {
    switch (status) {
      case SlaStatus.good:
        return 'Good';
      case SlaStatus.average:
        return 'Average';
      case SlaStatus.poor:
        return 'Poor';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 840;

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Flex(
                        direction: isDesktop ? Axis.horizontal : Axis.vertical,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _metricData!.metricName,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  '${_metricData!.uptimeRate.toStringAsFixed(2)}%',
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(_metricData!.status, theme),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Floor Threshold: 99%+ service availability',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isDesktop) const SizedBox(width: 32.0),
                          if (!isDesktop) const SizedBox(height: 24.0),
                          Column(
                            crossAxisAlignment: isDesktop ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Chip(
                                avatar: Icon(
                                  Icons.circle,
                                  size: 12.0,
                                  color: _getStatusColor(_metricData!.status, theme),
                                ),
                                label: Text(
                                  _getStatusLabel(_metricData!.status),
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: _getStatusColor(_metricData!.status, theme),
                                  ),
                                ),
                                backgroundColor: _getStatusColor(_metricData!.status, theme).withOpacity(0.12),
                                side: BorderSide.none,
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                'Last updated: ${_formatTime(_metricData!.lastUpdated)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              SizedBox(
                                height: 48.0,
                                width: 48.0,
                                child: IconButton(
                                  iconSize: 24.0,
                                  onPressed: _fetchData,
                                  icon: const Icon(Icons.refresh),
                                  tooltip: 'Refresh metrics',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}
