// GEN-02571 — Linter Compliance Status Card for Engineering Console.
// Displays UI Compliance Rate with M3 Elevated Card, status chips, 30s polling, and pull-to-refresh. Single-column mobile layout.

import 'dart:async';
import 'package:flutter/material.dart';

enum LinterComplianceStatus { pass, fail }

class LinterComplianceData {
  final double complianceRate;
  final LinterComplianceStatus status;
  final DateTime timestamp;
  final String traceId;

  const LinterComplianceData({
    required this.complianceRate,
    required this.status,
    required this.timestamp,
    required this.traceId,
  });
}

class MockLinterRepository {
  static const List<LinterComplianceData> _mockHistory = [
    LinterComplianceData(
      complianceRate: 1.0,
      status: LinterComplianceStatus.pass,
      timestamp: DateTime(2026, 9, 25, 10, 0),
      traceId: 'trace-001-gen-02571',
    ),
    LinterComplianceData(
      complianceRate: 0.98,
      status: LinterComplianceStatus.pass,
      timestamp: DateTime(2026, 9, 25, 10, 5),
      traceId: 'trace-002-gen-02571',
    ),
    LinterComplianceData(
      complianceRate: 0.92,
      status: LinterComplianceStatus.fail,
      timestamp: DateTime(2026, 9, 25, 10, 10),
      traceId: 'trace-003-gen-02571',
    ),
  ];

  int _index = 0;

  Future<LinterComplianceData> fetchLatest() async {
    await Future.delayed(const Duration(milliseconds: 80));
    final data = _mockHistory[_index % _mockHistory.length];
    _index++;
    return data;
  }
}

class LinterComplianceCard extends StatefulWidget {
  const LinterComplianceCard({super.key});

  @override
  State<LinterComplianceCard> createState() => _LinterComplianceCardState();
}

class _LinterComplianceCardState extends State<LinterComplianceCard> {
  final MockLinterRepository _repository = MockLinterRepository();
  LinterComplianceData? _currentData;
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _startPolling();
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
      final data = await _repository.fetchLatest();
      if (mounted) {
        setState(() {
          _currentData = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchData();
    });
  }

  Color _getStatusColor(BuildContext context, LinterComplianceStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case LinterComplianceStatus.pass:
        return colorScheme.primary;
      case LinterComplianceStatus.fail:
        return colorScheme.error;
    }
  }

  String _getStatusLabel(LinterComplianceStatus status) {
    switch (status) {
      case LinterComplianceStatus.pass:
        return 'Pass';
      case LinterComplianceStatus.fail:
        return 'Fail';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16.0 : 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Engineering Console - Linter Compliance',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _isLoading && _currentData == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : _buildCardContent(
                            context,
                            colorScheme,
                            textTheme,
                            isMobile,
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardContent(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isMobile,
  ) {
    if (_currentData == null) {
      return const Text('No compliance data available.');
    }

    final data = _currentData!;
    final statusColor = _getStatusColor(context, data.status);
    final percentage = (data.complianceRate * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'UI Compliance Rate (%)',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Chip(
              label: Text(
                _getStatusLabel(data.status),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              backgroundColor: statusColor.withOpacity(0.12),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '$percentage%',
          style: textTheme.displaySmall?.copyWith(
            color: statusColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: data.complianceRate.clamp(0.0, 1.0),
          minHeight: 8,
          backgroundColor: colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(statusColor),
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 24),
        Divider(color: colorScheme.outlineVariant),
        const SizedBox(height: 16),
        if (!isMobile)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDetailItem('Floor Threshold', '95%', textTheme)),
              Expanded(child: _buildDetailItem('Optimal Target', '100%', textTheme)),
              Expanded(child: _buildDetailItem('Trace ID', data.traceId, textTheme)),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Floor Threshold', '95%', textTheme),
              const SizedBox(height: 12),
              _buildDetailItem('Optimal Target', '100%', textTheme),
              const SizedBox(height: 12),
              _buildDetailItem('Trace ID', data.traceId, textTheme),
            ],
          ),
        const SizedBox(height: 24),
        Text(
          'Last Updated: ${_formatTimestamp(data.timestamp)}',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Drilling down into step details...'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.open_in_new, size: 20),
            label: const Text('View Step Details'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(48, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }
}
