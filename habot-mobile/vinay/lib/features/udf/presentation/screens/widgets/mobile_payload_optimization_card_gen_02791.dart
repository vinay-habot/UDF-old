// GEN-02791 — Mobile Payload Optimization Status Card.
// Displays task completion status for mobile payload optimization using M3 ElevatedCard, StatusChip, 30s polling, and pull-to-refresh. Single-column mobile (<600dp), multi-column desktop (>=840dp).

import 'dart:async';
import 'package:flutter/material.dart';

enum TaskCompletionStatus { complete, partial, notComplete }

class PayloadOptimizationRecord {
  final String traceId;
  final TaskCompletionStatus status;
  final DateTime timestamp;
  final String sessionId;
  final double metricValue;

  const PayloadOptimizationRecord({
    required this.traceId,
    required this.status,
    required this.timestamp,
    required this.sessionId,
    required this.metricValue,
  });
}

class MockPayloadOptimizationRepository {
  static const List<PayloadOptimizationRecord> mockRecords = [
    PayloadOptimizationRecord(
      traceId: 'trace-gen-02791-001',
      status: TaskCompletionStatus.complete,
      timestamp: DateTime(2026, 9, 25, 10, 0),
      sessionId: 'sess-mobile-eng-01',
      metricValue: 1.0,
    ),
    PayloadOptimizationRecord(
      traceId: 'trace-gen-02791-002',
      status: TaskCompletionStatus.partial,
      timestamp: DateTime(2026, 9, 25, 10, 5),
      sessionId: 'sess-mobile-eng-02',
      metricValue: 0.85,
    ),
    PayloadOptimizationRecord(
      traceId: 'trace-gen-02791-003',
      status: TaskCompletionStatus.notComplete,
      timestamp: DateTime(2026, 9, 25, 10, 10),
      sessionId: 'sess-mobile-eng-03',
      metricValue: 0.4,
    ),
  ];

  Future<List<PayloadOptimizationRecord>> fetchRecords() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockRecords;
  }
}

class MobilePayloadOptimizationCardGen02791 extends StatefulWidget {
  const MobilePayloadOptimizationCardGen02791({super.key});

  @override
  State<MobilePayloadOptimizationCardGen02791> createState() => _MobilePayloadOptimizationCardGen02791State();
}

class _MobilePayloadOptimizationCardGen02791State extends State<MobilePayloadOptimizationCardGen02791> {
  final MockPayloadOptimizationRepository _repository = MockPayloadOptimizationRepository();
  List<PayloadOptimizationRecord> _records = [];
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
    final data = await _repository.fetchRecords();
    if (!mounted) return;
    setState(() {
      _records = data;
      _isLoading = false;
    });
  }

  String _statusToString(TaskCompletionStatus status) {
    switch (status) {
      case TaskCompletionStatus.complete:
        return 'Complete';
      case TaskCompletionStatus.partial:
        return 'Partial';
      case TaskCompletionStatus.notComplete:
        return 'Not Complete';
    }
  }

  Color _statusColor(TaskCompletionStatus status, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case TaskCompletionStatus.complete:
        return colorScheme.primary;
      case TaskCompletionStatus.partial:
        return colorScheme.tertiary;
      case TaskCompletionStatus.notComplete:
        return colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 840;
        final crossAxisCount = isDesktop ? 2 : 1;

        return RefreshIndicator(
          onRefresh: _loadData,
          child: _isLoading && _records.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: isDesktop ? 2.5 : 2.0,
                  ),
                  itemCount: _records.length,
                  itemBuilder: (context, index) {
                    final record = _records[index];
                    return _buildElevatedCard(context, record);
                  },
                ),
        );
      },
    );
  }

  Widget _buildElevatedCard(BuildContext context, PayloadOptimizationRecord record) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _showConfigBottomSheet(context, record),
      borderRadius: BorderRadius.circular(12.0),
      child: Card(
        elevation: 3.0,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Payload Optimization',
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(context, record.status),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                'Trace ID: ${record.traceId}',
                style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              Text(
                'Metric Value: ${record.metricValue.toStringAsFixed(2)}',
                style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              Text(
                'Status: ${_statusToString(record.status)}',
                style: textTheme.bodyMedium,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${record.timestamp.hour}:${record.timestamp.minute.toString().padLeft(2, '0')}',
                  style: textTheme.labelSmall?.copyWith(color: colorScheme.outline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, TaskCompletionStatus status) {
    return Chip(
      label: Text(
        _statusToString(status),
        style: TextStyle(
          color: _statusColor(status, context),
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
      backgroundColor: _statusColor(status, context).withOpacity(0.12),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showConfigBottomSheet(BuildContext context, PayloadOptimizationRecord record) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configuration Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16.0),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Trace ID'),
                subtitle: Text(record.traceId),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Session ID'),
                subtitle: Text(record.sessionId),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Completion Status'),
                subtitle: Text(_statusToString(record.status)),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Configuration acknowledged.'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                    );
                  },
                  child: const Text('Acknowledge'),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }
}