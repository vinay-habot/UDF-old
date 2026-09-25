// GEN-02593 — Mobile UI for Liveness Handshake & Self-Healing Status.
// Defines the timeout threshold that triggers the Offline screen, featuring M3 Elevated Cards, status chips, background polling, and pull-to-refresh.

import 'dart:async';
import 'package:flutter/material.dart';

enum CompletionStatus { complete, partial, notComplete }

class MockLivenessData {
  final String stepId;
  final String stepName;
  final CompletionStatus status;
  final double processCompletionRate;
  final DateTime lastChecked;
  final int timeoutThresholdMs;

  const MockLivenessData({
    required this.stepId,
    required this.stepName,
    required this.status,
    required this.processCompletionRate,
    required this.lastChecked,
    required this.timeoutThresholdMs,
  });
}

class OfflineThresholdScreenGen02593 extends StatefulWidget {
  const OfflineThresholdScreenGen02593({super.key});

  @override
  State<OfflineThresholdScreenGen02593> createState() => _OfflineThresholdScreenState();
}

class _OfflineThresholdScreenState extends State<OfflineThresholdScreenGen02593> {
  Timer? _pollingTimer;
  bool _isOffline = false;
  late List<MockLivenessData> _mockData;
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

  static const int _offlineTimeoutThresholdMs = 5000;
  static const Duration _pollingInterval = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _initializeMockData() {
    _mockData = [
      MockLivenessData(
        stepId: 'GEN-02593',
        stepName: 'Liveness Handshake & Self-Healing',
        status: CompletionStatus.complete,
        processCompletionRate: 1.0,
        lastChecked: DateTime.now(),
        timeoutThresholdMs: _offlineTimeoutThresholdMs,
      ),
      MockLivenessData(
        stepId: 'GEN-02592',
        stepName: 'Prior Foundational Step',
        status: CompletionStatus.partial,
        processCompletionRate: 0.65,
        lastChecked: DateTime.now().subtract(const Duration(seconds: 15)),
        timeoutThresholdMs: _offlineTimeoutThresholdMs,
      ),
    ];
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) => _refreshData());
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 80)); // Simulate sub-100ms API latency
    if (!mounted) return;
    setState(() {
      _initializeMockData();
      _evaluateOfflineStatus();
    });
  }

  void _evaluateOfflineStatus() {
    final now = DateTime.now();
    bool anyStale = false;
    for (final data in _mockData) {
      if (now.difference(data.lastChecked).inMilliseconds > data.timeoutThresholdMs) {
        anyStale = true;
        break;
      }
    }
    _isOffline = anyStale;
  }

  Color _getStatusColor(CompletionStatus status, ColorScheme colorScheme) {
    switch (status) {
      case CompletionStatus.complete:
        return colorScheme.primary;
      case CompletionStatus.partial:
        return colorScheme.tertiary;
      case CompletionStatus.notComplete:
        return colorScheme.error;
    }
  }

  String _getStatusLabel(CompletionStatus status) {
    switch (status) {
      case CompletionStatus.complete:
        return 'Complete';
      case CompletionStatus.partial:
        return 'Partial';
      case CompletionStatus.notComplete:
        return 'Not Complete';
    }
  }

  void _showConfigBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Configure Timeout Threshold', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text('Current Threshold: $_offlineTimeoutThresholdMs ms'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configuration saved successfully.')),
                    );
                  },
                  child: const Text('Apply Configuration'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_isOffline) {
      return Scaffold(
        backgroundColor: colorScheme.errorContainer,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off_rounded, size: 64, color: colorScheme.onErrorContainer),
                const SizedBox(height: 16),
                Text(
                  'System Offline',
                  style: textTheme.headlineMedium?.copyWith(color: colorScheme.onErrorContainer),
                ),
                const SizedBox(height: 8),
                Text(
                  'Timeout threshold of $_offlineTimeoutThresholdMs ms exceeded. Awaiting self-healing handshake.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onErrorContainer),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator(color: colorScheme.onErrorContainer),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Console'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configure Threshold',
            onPressed: () => _showConfigBottomSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 840;
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: isDesktop
                  ? Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: _mockData.map((data) => SizedBox(width: 400, child: _buildCard(data, colorScheme, textTheme))).toList(),
                    )
                  : Column(
                      children: _mockData.map((data) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildCard(data, colorScheme, textTheme),
                      )).toList(),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(MockLivenessData data, ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Deep-link drill-down placeholder
        },
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
                      data.stepName,
                      style: textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Chip(
                    label: Text(
                      _getStatusLabel(data.status),
                      style: TextStyle(color: _getStatusColor(data.status, colorScheme)),
                    ),
                    backgroundColor: _getStatusColor(data.status, colorScheme).withOpacity(0.12),
                    side: BorderSide.none,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Step ID: ${data.stepId}', style: textTheme.bodySmall),
              const SizedBox(height: 4),
              Text('Process Completion Rate: ${(data.processCompletionRate * 100).toStringAsFixed(1)}%', style: textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text('Timeout Threshold: ${data.timeoutThresholdMs} ms', style: textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text('Last Checked: ${data.lastChecked.toIso8601String().substring(11, 19)}', style: textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
            ],
          ),
        ),
      ),
    );
  }
}
