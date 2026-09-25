// GEN-02780 — Real-Time Dashboard Polling Card with M3 Status Indicators.
// Implements a 60-second background polling mechanism for dashboard data refresh, featuring Material 3 Elevated Cards, status chips, and pull-to-refresh support.

import 'dart:async';
import 'package:flutter/material.dart';

/// Mock data model representing the real-time event delivery state.
class DashboardEventState {
  final String traceId;
  final DateTime timestamp;
  final int latencyMs;
  final String qualitativeStatus; // Good / Average / Poor

  const DashboardEventState({
    required this.traceId,
    required this.timestamp,
    required this.latencyMs,
    required this.qualitativeStatus,
  });
}

/// Mock repository simulating backend API response per RFC 6455 standards.
class MockDashboardRepository {
  static Future<DashboardEventState> fetchLatestEvent() async {
    await Future.delayed(const Duration(milliseconds: 120)); // Simulate sub-200ms optimal target
    final randomLatency = (DateTime.now().millisecond % 400) + 50;
    String status = 'Good';
    if (randomLatency > 500) {
      status = 'Poor';
    } else if (randomLatency > 200) {
      status = 'Average';
    }
    return DashboardEventState(
      traceId: 'trace_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      latencyMs: randomLatency,
      qualitativeStatus: status,
    );
  }
}

/// Background polling service that triggers every 60 seconds.
class DashboardPollingService {
  Timer? _timer;
  final void Function(DashboardEventState) onDataRefreshed;
  final void Function(Object error) onError;

  DashboardPollingService({
    required this.onDataRefreshed,
    required this.onError,
  });

  void start() {
    _fetch(); // Immediate first fetch
    _timer = Timer.periodic(const Duration(seconds: 60), (_) => _fetch());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _fetch() async {
    try {
      final data = await MockDashboardRepository.fetchLatestEvent();
      onDataRefreshed(data);
    } catch (e) {
      onError(e);
    }
  }

  Future<void> manualRefresh() async => _fetch();
}

/// Main UI Widget implementing M3 responsive layout and polling integration.
class DashboardPollingCardGen02780 extends StatefulWidget {
  const DashboardPollingCardGen02780({super.key});

  @override
  State<DashboardPollingCardGen02780> createState() => _DashboardPollingCardGen02780State();
}

class _DashboardPollingCardGen02780State extends State<DashboardPollingCardGen02780> {
  late final DashboardPollingService _pollingService;
  DashboardEventState? _currentState;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _pollingService = DashboardPollingService(
      onDataRefreshed: _handleDataRefreshed,
      onError: _handleError,
    );
    _pollingService.start();
  }

  @override
  void dispose() {
    _pollingService.stop();
    super.dispose();
  }

  void _handleDataRefreshed(DashboardEventState state) {
    if (!mounted) return;
    setState(() {
      _currentState = state;
      _isRefreshing = false;
    });
  }

  void _handleError(Object error) {
    if (!mounted) return;
    setState(() => _isRefreshing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Real-time sync failed: $error'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _onManualRefresh() async {
    setState(() => _isRefreshing = true);
    await _pollingService.manualRefresh();
  }

  Color _getStatusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case 'Good':
        return colorScheme.primary;
      case 'Average':
        return colorScheme.tertiary;
      case 'Poor':
        return colorScheme.error;
      default:
        return colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 840;

    return RefreshIndicator(
      onRefresh: _onManualRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: isDesktop ? _buildMultiColumnLayout(context) : _buildSingleColumnLayout(context),
      ),
    );
  }

  Widget _buildSingleColumnLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        _buildStatusCard(context),
      ],
    );
  }

  Widget _buildMultiColumnLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildHeader(context)),
        const SizedBox(width: 24),
        Expanded(child: _buildStatusCard(context)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Engineering Console', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Real-Time Event Delivery Latency',
          style: textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        if (_isRefreshing)
          const LinearProgressIndicator()
        else
          const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final theme = Theme.of(context);
    final state = _currentState;

    return Card(
      elevation: 3.0, // M3 Elevated Card Level 2 (approx 3dp)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Step Health', style: theme.textTheme.titleLarge),
                if (state != null)
                  Chip(
                    avatar: Icon(
                      Icons.circle,
                      size: 12,
                      color: _getStatusColor(context, state.qualitativeStatus),
                    ),
                    label: Text(state.qualitativeStatus),
                  ),
              ],
            ),
            const Divider(height: 32),
            if (state == null) ...[
              const Center(child: CircularProgressIndicator()),
            ] else ...[
              _buildInfoRow(context, 'Trace ID', state.traceId),
              const SizedBox(height: 12),
              _buildInfoRow(context, 'Latency', '${state.latencyMs} ms'),
              const SizedBox(height: 12),
              _buildInfoRow(context, 'Last Sync', _formatTime(state.timestamp)),
              const SizedBox(height: 12),
              _buildInfoRow(context, 'Target', '< 200 ms (Optimal)'),
            ],
            const SizedBox(height: 24),
            SizedBox(
              height: 48, // 48x48dp touch targets
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isRefreshing ? null : _onManualRefresh,
                icon: const Icon(Icons.sync),
                label: const Text('Force Sync'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        Text(value, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}
