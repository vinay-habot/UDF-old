// GEN-02890 — Reconciliation Status ListTile with trailing icons.
// Renders reconciliation status using Material 3 ListTile with trailing icons on mobile. Includes mock data, M3 Elevated Cards, and responsive layout constraints.

import 'package:flutter/material.dart';

enum ReconciliationStatus { passed, failed, pending }

class ReconciliationRecord {
  final String id;
  final String title;
  final double varianceDelta;
  final ReconciliationStatus status;
  final DateTime timestamp;

  const ReconciliationRecord({
    required this.id,
    required this.title,
    required this.varianceDelta,
    required this.status,
    required this.timestamp,
  });
}

class MockReconciliationRepository {
  static const List<ReconciliationRecord> records = [
    ReconciliationRecord(
      id: 'REC-001',
      title: 'Ledger Sync Alpha',
      varianceDelta: 0.005,
      status: ReconciliationStatus.passed,
      timestamp: DateTime(2026, 9, 25, 10, 0),
    ),
    ReconciliationRecord(
      id: 'REC-002',
      title: 'Ledger Sync Beta',
      varianceDelta: 0.06,
      status: ReconciliationStatus.failed,
      timestamp: DateTime(2026, 9, 25, 10, 15),
    ),
    ReconciliationRecord(
      id: 'REC-003',
      title: 'Ledger Sync Gamma',
      varianceDelta: 0.03,
      status: ReconciliationStatus.pending,
      timestamp: DateTime(2026, 9, 25, 10, 30),
    ),
  ];
}

class ReconciliationStatusListTileGen02890 extends StatelessWidget {
  final ReconciliationRecord record;
  final VoidCallback? onTap;

  const ReconciliationStatusListTileGen02890({
    super.key,
    required this.record,
    this.onTap,
  });

  Color _statusColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (record.status) {
      case ReconciliationStatus.passed:
        return colorScheme.primary;
      case ReconciliationStatus.failed:
        return colorScheme.error;
      case ReconciliationStatus.pending:
        return colorScheme.tertiary;
    }
  }

  IconData _statusIcon() {
    switch (record.status) {
      case ReconciliationStatus.passed:
        return Icons.check_circle_rounded;
      case ReconciliationStatus.failed:
        return Icons.error_rounded;
      case ReconciliationStatus.pending:
        return Icons.pending_actions_rounded;
    }
  }

  String _qualitativeOutput() {
    if (record.varianceDelta <= 0.01) return 'Pass';
    if (record.varianceDelta > 0.05) return 'Fail';
    return 'Review';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _statusColor(context);

    return Semantics(
      label: '${record.title}, Status: ${_qualitativeOutput()}, Variance: ${record.varianceDelta}',
      child: Card(
        elevation: 3.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          minVerticalPadding: 12.0,
          onTap: onTap ?? () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Drill-down for ${record.id}'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          leading: Container(
            width: 48.0,
            height: 48.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _statusIcon(),
              color: statusColor,
              size: 24.0,
            ),
          ),
          title: Text(
            record.title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${record.id} | Delta: ${record.varianceDelta.toStringAsFixed(3)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6.0),
                Chip(
                  label: Text(
                    _qualitativeOutput(),
                    style: textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: statusColor.withOpacity(0.12),
                  side: BorderSide.none,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16.0,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class ReconciliationStatusScreenGen02890 extends StatefulWidget {
  const ReconciliationStatusScreenGen02890({super.key});

  @override
  State<ReconciliationStatusScreenGen02890> createState() => _ReconciliationStatusScreenGen02890State();
}

class _ReconciliationStatusScreenGen02890State extends State<ReconciliationStatusScreenGen02890> {
  late List<ReconciliationRecord> _records;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _records = MockReconciliationRepository.records.toList();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data synced successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 840;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reconciliation Status'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {},
            tooltip: 'Engineering Console Info',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (isDesktop) {
              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  mainAxisExtent: 120,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  return ReconciliationStatusListTileGen02890(
                    record: _records[index],
                  );
                },
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                return ReconciliationStatusListTileGen02890(
                  record: _records[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}