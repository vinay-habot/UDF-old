// GEN-03044 — Identity Verification Preventive Control M3 Status Card.
// Displays task completion state with background polling, pull-to-refresh, and deep-link drill-down in a single-column mobile layout using Material 3 Elevated Cards and Status Chips.

import 'dart:async';
import 'package:flutter/material.dart';

enum TaskCompletionStatus { complete, partial, notComplete }

class IdentityVerificationMockData {
  static const String atomicId = 'GEN-03044';
  static const String title = 'Identity Verification Requirement';
  static const String description = 'Implement automated preventive control: identity verification requirement.';
  static const TaskCompletionStatus status = TaskCompletionStatus.complete;
  static const double metricValue = 1.0;
  static const String lastUpdated = '2026-09-25T10:00:00Z';
  static const String traceId = 'trace-gen-03044-001';
}

class IdentityVerificationCardGen03044 extends StatefulWidget {
  const IdentityVerificationCardGen03044({super.key});

  @override
  State<IdentityVerificationCardGen03044> createState() => _IdentityVerificationCardGen03044State();
}

class _IdentityVerificationCardGen03044State extends State<IdentityVerificationCardGen03044> {
  Timer? _pollingTimer;
  bool _isRefreshing = false;
  TaskCompletionStatus _currentStatus = IdentityVerificationMockData.status;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchMockData();
    });
  }

  Future<void> _fetchMockData() async {
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 80)); // Sub-100ms mock latency
    setState(() {
      _currentStatus = IdentityVerificationMockData.status;
    });
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await _fetchMockData();
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sync complete'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Color _getStatusColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (_currentStatus) {
      case TaskCompletionStatus.complete:
        return colorScheme.primary;
      case TaskCompletionStatus.partial:
        return colorScheme.tertiary;
      case TaskCompletionStatus.notComplete:
        return colorScheme.error;
    }
  }

  String _getStatusLabel() {
    switch (_currentStatus) {
      case TaskCompletionStatus.complete:
        return 'Complete';
      case TaskCompletionStatus.partial:
        return 'Partial';
      case TaskCompletionStatus.notComplete:
        return 'Not Complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Engineering Console',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: InkWell(
                  onTap: () {
                    // Deep-link drill-down placeholder
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => _buildConfigBottomSheet(context),
                    );
                  },
                  borderRadius: BorderRadius.circular(12.0),
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
                                IdentityVerificationMockData.title,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(
                                _getStatusLabel(),
                                style: TextStyle(
                                  color: colorScheme.onPrimaryContainer,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: _getStatusColor(context).withOpacity(0.15),
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          IdentityVerificationMockData.description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              size: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Metric: ${(IdentityVerificationMockData.metricValue * 100).toStringAsFixed(0)}%',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'ID: ${IdentityVerificationMockData.atomicId}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isRefreshing)
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              // Ensuring minimum height for pull-to-refresh to work on short lists
              const SizedBox(height: 400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigBottomSheet(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Trace ID'),
              subtitle: Text(IdentityVerificationMockData.traceId),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Last Updated'),
              subtitle: Text(IdentityVerificationMockData.lastUpdated),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48, // 48x48dp touch targets
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}