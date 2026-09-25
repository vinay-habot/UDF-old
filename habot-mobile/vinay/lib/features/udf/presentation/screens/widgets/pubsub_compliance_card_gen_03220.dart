// GEN-03220 — Pub/Sub Compliance Event Status Card.
// Displays compliance event payload routing health via M3 Elevated Card with inline status chip, 30s polling, and pull-to-refresh.

import 'dart:async';
import 'package:flutter/material.dart';

enum ComplianceStatus { pass, fail, pending }

class PubSubComplianceEvent {
  final String traceId;
  final DateTime eventDate;
  final double deliveryRate;
  final ComplianceStatus status;
  final String sessionId;

  const PubSubComplianceEvent({
    required this.traceId,
    required this.eventDate,
    required this.deliveryRate,
    required this.status,
    required this.sessionId,
  });
}

class MockPubSubRepository {
  static const double _floorThreshold = 0.9999;

  Future<PubSubComplianceEvent> fetchLatestEvent() async {
    await Future.delayed(const Duration(milliseconds: 450));
    final rate = 0.99995;
    return PubSubComplianceEvent(
      traceId: 'trace-${DateTime.now().millisecondsSinceEpoch}',
      eventDate: DateTime.now(),
      deliveryRate: rate,
      status: rate >= _floorThreshold ? ComplianceStatus.pass : ComplianceStatus.fail,
      sessionId: 'session-gen-03220',
    );
  }
}

class PubSubComplianceCardGen03220 extends StatefulWidget {
  const PubSubComplianceCardGen03220({super.key});

  @override
  State<PubSubComplianceCardGen03220> createState() => _PubSubComplianceCardGen03220State();
}

class _PubSubComplianceCardGen03220State extends State<PubSubComplianceCardGen03220> {
  final MockPubSubRepository _repository = MockPubSubRepository();
  PubSubComplianceEvent? _event;
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
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
      final event = await _repository.fetchLatestEvent();
      if (mounted) {
        setState(() {
          _event = event;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= 840;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isDesktop ? _buildDesktopLayout(theme) : _buildMobileLayout(theme),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(theme),
        const SizedBox(height: 16),
        _buildStatusCard(theme),
        const SizedBox(height: 16),
        _buildMetricsCard(theme),
      ],
    );
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildStatusCard(theme)),
        const SizedBox(width: 24),
        Expanded(child: _buildMetricsCard(theme)),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Semantics(
      header: true,
      child: Text(
        'Compliance Event Routing',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    return Card(
      elevation: 3.0,
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
                Expanded(
                  child: Text(
                    'Pub/Sub Delivery Status',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                _buildStatusChip(theme),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const LinearProgressIndicator()
            else if (_event != null)
              ...[
                Text('Trace ID: ${_event!.traceId}', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(
                  'Last Sync: ${_formatDate(_event!.eventDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ]
            else
              Text('No data available', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    final status = _event?.status ?? ComplianceStatus.pending;
    Color bgColor;
    Color fgColor;
    String label;

    switch (status) {
      case ComplianceStatus.pass:
        bgColor = theme.colorScheme.primaryContainer;
        fgColor = theme.colorScheme.onPrimaryContainer;
        label = 'Pass';
        break;
      case ComplianceStatus.fail:
        bgColor = theme.colorScheme.errorContainer;
        fgColor = theme.colorScheme.onErrorContainer;
        label = 'Fail';
        break;
      case ComplianceStatus.pending:
        bgColor = theme.colorScheme.surfaceContainerHighest;
        fgColor = theme.colorScheme.onSurfaceVariant;
        label = 'Pending';
        break;
    }

    return Chip(
      avatar: Icon(status == ComplianceStatus.pass ? Icons.check_circle : Icons.info_outline, size: 18, color: fgColor),
      label: Text(label, style: TextStyle(color: fgColor, fontWeight: FontWeight.bold)),
      backgroundColor: bgColor,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildMetricsCard(ThemeData theme) {
    return Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery Rate Metrics', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            _buildMetricRow(theme, 'Current Rate', _event != null ? '${(_event!.deliveryRate * 100).toStringAsFixed(4)}%' : '--'),
            const Divider(height: 24),
            _buildMetricRow(theme, 'Floor Threshold', '99.99%'),
            const Divider(height: 24),
            _buildMetricRow(theme, 'Optimal Target', '100%'),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () => _showConfigSheet(context),
                icon: const Icon(Icons.settings_outlined, size: 20),
                label: const Text('View Configuration'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyLarge),
        Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, fontFeatures: const [FontFeature.tabularFigures()])),
      ],
    );
  }

  void _showConfigSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GCP Streaming Pipeline Standards', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text(
                'All step execution events stream to BigQuery partitioned by event_date, clustered by trace_id.',
                style: Theme.of(ctx).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configuration acknowledged')),
                    );
                  },
                  child: const Text('Acknowledge'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }
}