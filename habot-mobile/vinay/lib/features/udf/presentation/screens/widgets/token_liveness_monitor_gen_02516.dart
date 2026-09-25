// GEN-02516 — Token Liveness Monitor Engineering Console Widget.
// Displays M3 Elevated Cards with status chips for nightly inactive user token verification, including mock telemetry data and 30-second polling simulation.

import 'dart:async';
import 'package:flutter/material.dart';

enum _VerificationStatus { pass, fail, pending }

class _MockTokenVerificationEvent {
  final String traceId;
  final String userId;
  final DateTime timestamp;
  final _VerificationStatus status;
  final double authPassRate;

  const _MockTokenVerificationEvent({
    required this.traceId,
    required this.userId,
    required this.timestamp,
    required this.status,
    required this.authPassRate,
  });
}

final List<_MockTokenVerificationEvent> _mockEvents = [
  _MockTokenVerificationEvent(
    traceId: 'trc-99281-a',
    userId: 'inactive_usr_001',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    status: _VerificationStatus.pass,
    authPassRate: 0.9999,
  ),
  _MockTokenVerificationEvent(
    traceId: 'trc-99282-b',
    userId: 'inactive_usr_042',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    status: _VerificationStatus.fail,
    authPassRate: 0.9820,
  ),
  _MockTokenVerificationEvent(
    traceId: 'trc-99283-c',
    userId: 'inactive_usr_118',
    timestamp: DateTime.now(),
    status: _VerificationStatus.pass,
    authPassRate: 1.0,
  ),
];

class TokenLivenessMonitorGen02516 extends StatefulWidget {
  const TokenLivenessMonitorGen02516({super.key});

  @override
  State<TokenLivenessMonitorGen02516> createState() => _TokenLivenessMonitorGen02516State();
}

class _TokenLivenessMonitorGen02516State extends State<TokenLivenessMonitorGen02516> {
  Timer? _pollingTimer;
  bool _isPolling = true;
  List<_MockTokenVerificationEvent> _currentEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_isPolling) {
        _fetchData();
      }
    });
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      _currentEvents = List.from(_mockEvents);
    });
  }

  void _togglePolling() {
    setState(() {
      _isPolling = !_isPolling;
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Token Liveness Monitor'),
            actions: [
              IconButton(
                icon: Icon(_isPolling ? Icons.sync : Icons.sync_disabled),
                tooltip: _isPolling ? 'Pause 30s Polling' : 'Resume 30s Polling',
                onPressed: _togglePolling,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildKpiSummary(theme),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: isMobile ? 600 : 400,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: isMobile ? 2.5 : 2.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildEventCard(theme, _currentEvents[index]),
                childCount: _currentEvents.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32.0)),
        ],
      ),
    );
  }

  Widget _buildKpiSummary(ThemeData theme) {
    final passCount = _currentEvents.where((e) => e.status == _VerificationStatus.pass).length;
    final totalCount = _currentEvents.isEmpty ? 1 : _currentEvents.length;
    final overallRate = passCount / totalCount;
    final meetsThreshold = overallRate >= 0.995;

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Auth Pass Rate (%)', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(overallRate * 100).toStringAsFixed(2)}%',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: meetsThreshold ? theme.colorScheme.primary : theme.colorScheme.error,
                  ),
                ),
                Chip(
                  label: Text(meetsThreshold ? 'PASS' : 'FAIL', style: theme.textTheme.labelLarge),
                  backgroundColor: meetsThreshold
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.errorContainer,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Floor Threshold: 99.5% | OWASP 2021, RFC 7519 (JWT)',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(ThemeData theme, _MockTokenVerificationEvent event) {
    final isPass = event.status == _VerificationStatus.pass;

    return Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Drill-down for Trace ID: ${event.traceId}'),
              behavior: SnackBarBehavior.floating,
            ),
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
                      event.userId,
                      style: theme.textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Chip(
                    avatar: Icon(
                      isPass ? Icons.check_circle : Icons.cancel,
                      size: 16.0,
                      color: isPass ? theme.colorScheme.primary : theme.colorScheme.error,
                    ),
                    label: Text(isPass ? 'Pass' : 'Fail'),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Text('Trace: ${event.traceId}', style: theme.textTheme.bodySmall),
              const SizedBox(height: 4.0),
              Text(
                'Rate: ${(event.authPassRate * 100).toStringAsFixed(2)}%',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}