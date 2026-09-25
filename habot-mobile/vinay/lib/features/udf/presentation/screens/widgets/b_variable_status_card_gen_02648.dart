// GEN-02648 — B Variable BigQuery Insert Status Card.
// Displays the count or sum of confirmed BigQuery inserts per pipeline using M3 Elevated Cards, status chips, 30s polling, and pull-to-refresh. Single-column mobile (<600dp), multi-column desktop (>=840dp).

import 'dart:async';
import 'package:flutter/material.dart';

/// Mock data representing the B variable: count/sum of confirmed BigQuery inserts per pipeline.
class PipelineInsertData {
  final String pipelineId;
  final String pipelineName;
  final int confirmedInserts;
  final bool triangularCheckPass;
  final DateTime lastUpdated;

  const PipelineInsertData({
    required this.pipelineId,
    required this.pipelineName,
    required this.confirmedInserts,
    required this.triangularCheckPass,
    required this.lastUpdated,
  });
}

/// Mock repository simulating backend/BigQuery API response.
class MockPipelineRepository {
  static Future<List<PipelineInsertData>> fetchPipelineInserts() async {
    await Future.delayed(const Duration(milliseconds: 45)); // Sub-100ms latency simulation
    final now = DateTime.now();
    return [
      PipelineInsertData(
        pipelineId: 'trace-001',
        pipelineName: 'User Events Pipeline',
        confirmedInserts: 14520,
        triangularCheckPass: true,
        lastUpdated: now,
      ),
      PipelineInsertData(
        pipelineId: 'trace-002',
        pipelineName: 'Transaction Ledger',
        confirmedInserts: 8930,
        triangularCheckPass: true,
        lastUpdated: now,
      ),
      PipelineInsertData(
        pipelineId: 'trace-003',
        pipelineName: 'Telemetry Stream',
        confirmedInserts: 32100,
        triangularCheckPass: false,
        lastUpdated: now,
      ),
      PipelineInsertData(
        pipelineId: 'trace-004',
        pipelineName: 'Analytics Aggregation',
        confirmedInserts: 5400,
        triangularCheckPass: true,
        lastUpdated: now,
      ),
    ];
  }
}

class BVariableStatusCard extends StatefulWidget {
  const BVariableStatusCard({super.key});

  @override
  State<BVariableStatusCard> createState() => _BVariableStatusCardState();
}

class _BVariableStatusCardState extends State<BVariableStatusCard> {
  List<PipelineInsertData> _data = [];
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    // Background polling refreshes data every 30 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchData());
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
      final inserts = await MockPipelineRepository.fetchPipelineInserts();
      if (mounted) {
        setState(() {
          _data = inserts;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Pipeline B Variable Status'),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        color: colorScheme.primary,
        child: _isLoading && _data.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  // M3 responsive layout: single-column on mobile (<600dp), multi-column on desktop (>=840dp)
                  final isDesktop = constraints.maxWidth >= 840;
                  final crossAxisCount = isDesktop ? 2 : 1;

                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: isDesktop ? 2.8 : 2.4,
                    ),
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      final item = _data[index];
                      return _buildElevatedCard(context, item);
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _buildElevatedCard(BuildContext context, PipelineInsertData item) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () => _showConfigBottomSheet(context, item),
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
                      item.pipelineName,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // M3 Status Chips for health indicators
                  _buildStatusChip(item.triangularCheckPass),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.confirmedInserts}',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Confirmed Inserts',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                'Trace ID: ${item.pipelineId} • Updated: ${_formatTime(item.lastUpdated)}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool pass) {
    return Chip(
      avatar: Icon(
        pass ? Icons.check_circle_outline : Icons.error_outline,
        size: 18.0,
        color: pass ? Colors.green.shade700 : Colors.red.shade700,
      ),
      label: Text(
        pass ? 'Pass' : 'Fail',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: pass ? Colors.green.shade700 : Colors.red.shade700,
        ),
      ),
      backgroundColor: pass ? Colors.green.shade50 : Colors.red.shade50,
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  /// M3 Bottom Sheet for configuration inputs / deep-link drill-down
  void _showConfigBottomSheet(BuildContext context, PipelineInsertData item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24.0,
            right: 24.0,
            top: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 32.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                'Pipeline Details: ${item.pipelineName}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.storage_outlined),
                title: const Text('Confirmed BigQuery Inserts'),
                subtitle: Text('${item.confirmedInserts} records'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.verified_outlined),
                title: const Text('@triangular_check Decorator Coverage'),
                subtitle: Text(item.triangularCheckPass ? '100% Applied (Pass)' : 'Incomplete (Fail)'),
                trailing: Icon(
                  item.triangularCheckPass ? Icons.check_circle : Icons.cancel,
                  color: item.triangularCheckPass ? Colors.green : Colors.red,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.link),
                title: const Text('Trace ID'),
                subtitle: Text(item.pipelineId),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 48.0, // 48x48dp touch targets
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // M3 Snackbar for confirmations
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Configuration synced successfully.'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  child: const Text('Acknowledge & Sync'),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }
}
