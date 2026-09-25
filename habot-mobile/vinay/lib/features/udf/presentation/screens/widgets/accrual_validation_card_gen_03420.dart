// GEN-03420 — Accrual Validation Status Card.
// Displays M3 ElevatedCard with status chip for accrual mathematical accuracy validation in the engineering console.

import 'package:flutter/material.dart';

enum _ValidationStatus { pass, fail, pending }

class _AccrualValidationData {
  final String metricName;
  final double floorBoundary;
  final double optimalTarget;
  final double ceilingBoundary;
  final String qualitativeOutput;
  final _ValidationStatus status;
  final DateTime timestamp;
  final String traceId;

  const _AccrualValidationData({
    required this.metricName,
    required this.floorBoundary,
    required this.optimalTarget,
    required this.ceilingBoundary,
    required this.qualitativeOutput,
    required this.status,
    required this.timestamp,
    required this.traceId,
  });
}

const List<_AccrualValidationData> _mockValidationData = [
  _AccrualValidationData(
    metricName: 'Accrual Mathematical Accuracy',
    floorBoundary: 1.0,
    optimalTarget: 1.0,
    ceilingBoundary: 1.0,
    qualitativeOutput: 'Pass',
    status: _ValidationStatus.pass,
    timestamp: DateTime(2026, 9, 25, 10, 30),
    traceId: 'trace-gen-03420-001',
  ),
  _AccrualValidationData(
    metricName: 'Accrual Mathematical Accuracy',
    floorBoundary: 1.0,
    optimalTarget: 1.0,
    ceilingBoundary: 1.0,
    qualitativeOutput: 'Pass',
    status: _ValidationStatus.pass,
    timestamp: DateTime(2026, 9, 25, 10, 0),
    traceId: 'trace-gen-03420-002',
  ),
];

class AccrualValidationCardGen03420 extends StatefulWidget {
  const AccrualValidationCardGen03420({super.key});

  @override
  State<AccrualValidationCardGen03420> createState() => _AccrualValidationCardGen03420State();
}

class _AccrualValidationCardGen03420State extends State<AccrualValidationCardGen03420> {
  late List<_AccrualValidationData> _data;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _data = List.from(_mockValidationData);
    _startPolling();
  }

  void _startPolling() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _refreshData();
        _startPolling();
      }
    });
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 80));
    if (mounted) {
      setState(() {
        _data = List.from(_mockValidationData);
        _isRefreshing = false;
      });
    }
  }

  Color _statusColor(BuildContext context, _ValidationStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case _ValidationStatus.pass:
        return colorScheme.primary;
      case _ValidationStatus.fail:
        return colorScheme.error;
      case _ValidationStatus.pending:
        return colorScheme.tertiary;
    }
  }

  String _statusLabel(_ValidationStatus status) {
    switch (status) {
      case _ValidationStatus.pass:
        return 'PASS';
      case _ValidationStatus.fail:
        return 'FAIL';
      case _ValidationStatus.pending:
        return 'PENDING';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final crossAxisCount = isMobile ? 1 : (constraints.maxWidth >= 840 ? 2 : 1);

          return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: isMobile ? 2.8 : 3.2,
            ),
            itemCount: _data.length,
            itemBuilder: (context, index) {
              final item = _data[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _showDetailSheet(context, item),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.metricName,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(
                                _statusLabel(item.status),
                                style: textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: _statusColor(context, item.status),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              item.status == _ValidationStatus.pass
                                  ? Icons.check_circle_outline
                                  : Icons.error_outline,
                              size: 20,
                              color: _statusColor(context, item.status),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Output: ${item.qualitativeOutput}',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Text(
                          'Trace: ${item.traceId}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDetailSheet(BuildContext context, _AccrualValidationData item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
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
                  item.metricName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _DetailRow('Status', _statusLabel(item.status)),
                _DetailRow('Qualitative Output', item.qualitativeOutput),
                _DetailRow('Floor Boundary', item.floorBoundary.toString()),
                _DetailRow('Optimal Target', item.optimalTarget.toString()),
                _DetailRow('Ceiling Boundary', item.ceilingBoundary.toString()),
                _DetailRow('Trace ID', item.traceId),
                _DetailRow('Timestamp', item.timestamp.toIso8601String()),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Deep-link drill-down triggered'),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'DISMISS',
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new, size: 20),
                  label: const Text('Drill Down'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}