// GEN-03231 — PII Data Scrubbing Status Card.
// Displays edge-level PII scrubbing configuration health using M3 Elevated Cards and Status Chips. Implements single-column mobile layout with 30-second polling and pull-to-refresh.

import 'dart:async';
import 'package:flutter/material.dart';

enum ScrubbingStatus { pass, fail, pending }

class PiiScrubbingMetric {
  final String metricName;
  final double floorBoundary;
  final double optimalTarget;
  final double ceilingBoundary;
  final String qualitativeOutput;
  final String standardReference;
  final ScrubbingStatus status;
  final DateTime lastUpdated;

  const PiiScrubbingMetric({
    required this.metricName,
    required this.floorBoundary,
    required this.optimalTarget,
    required this.ceilingTarget,
    required this.qualitativeOutput,
    required this.standardReference,
    required this.status,
    required this.lastUpdated,
  });
}

class MockPiiScrubbingRepository {
  static PiiScrubbingMetric fetchCurrentMetric() {
    return PiiScrubbingMetric(
      metricName: 'PII Data Scrubbing Pass Rate',
      floorBoundary: 1.0,
      optimalTarget: 1.0,
      ceilingTarget: 1.0,
      qualitativeOutput: 'Pass',
      standardReference: 'GDPR / GACL Privacy Directives',
      status: ScrubbingStatus.pass,
      lastUpdated: DateTime.now(),
    );
  }
}

class PiiScrubbingStatusCardGen03231 extends StatefulWidget {
  const PiiScrubbingStatusCardGen03231({super.key});

  @override
  State<PiiScrubbingStatusCardGen03231> createState() => _PiiScrubbingStatusCardGen03231State();
}

class _PiiScrubbingStatusCardGen03231State extends State<PiiScrubbingStatusCardGen03231> {
  late PiiScrubbingMetric _metric;
  Timer? _pollingTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _metric = MockPiiScrubbingRepository.fetchCurrentMetric();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      setState(() {
        _metric = MockPiiScrubbingRepository.fetchCurrentMetric();
        _isRefreshing = false;
      });
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Color _getStatusColor(BuildContext context, ScrubbingStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case ScrubbingStatus.pass:
        return colorScheme.primary;
      case ScrubbingStatus.fail:
        return colorScheme.error;
      case ScrubbingStatus.pending:
        return colorScheme.tertiary;
    }
  }

  String _getStatusText(ScrubbingStatus status) {
    switch (status) {
      case ScrubbingStatus.pass:
        return 'PASS';
      case ScrubbingStatus.fail:
        return 'FAIL';
      case ScrubbingStatus.pending:
        return 'PENDING';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edge-Level PII Scrubbing',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Global Ref: GEN-03231 | Atomic Step: 9999',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _metric.metricName,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Chip(
                            label: Text(
                              _getStatusText(_metric.status),
                              style: textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: _getStatusColor(context, _metric.status),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      _buildInfoRow('Qualitative Output', _metric.qualitativeOutput, textTheme),
                      const SizedBox(height: 12),
                      _buildInfoRow('Standard Reference', _metric.standardReference, textTheme),
                      const SizedBox(height: 12),
                      _buildInfoRow('Floor Boundary', _metric.floorBoundary.toStringAsFixed(1), textTheme),
                      const SizedBox(height: 12),
                      _buildInfoRow('Optimal Target', _metric.optimalTarget.toStringAsFixed(1), textTheme),
                      const SizedBox(height: 12),
                      _buildInfoRow('Ceiling Boundary', _metric.ceilingTarget.toStringAsFixed(1), textTheme),
                      const SizedBox(height: 16),
                      Text(
                        'Last Updated: ${_formatDateTime(_metric.lastUpdated)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configuration Details',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Configure edge-level data scrubbing rules to strip personally identifiable information (PII). All step execution events stream to BigQuery partitioned by event_date, clustered by trace_id.',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showConfigBottomSheet(context),
                          icon: const Icon(Icons.settings_outlined),
                          label: const Text('View Configuration'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isRefreshing)
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }

  void _showConfigBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'PII Scrubbing Configuration',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.shield_outlined),
                          title: const Text('Data Scrubbing Rules'),
                          subtitle: const Text('Edge-level PII stripping enabled'),
                          trailing: Switch(
                            value: true,
                            onChanged: (_) {},
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.policy_outlined),
                          title: const Text('Compliance Standard'),
                          subtitle: const Text('GDPR / GACL Privacy Directives'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.analytics_outlined),
                          title: const Text('BigQuery Streaming'),
                          subtitle: const Text('Partitioned by event_date, clustered by trace_id'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.timer_outlined),
                          title: const Text('Liveness Handshake'),
                          subtitle: const Text('Automated monitoring every 30 seconds'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Configuration acknowledged'),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'DISMISS',
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                      child: const Text('Confirm & Close'),
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
}