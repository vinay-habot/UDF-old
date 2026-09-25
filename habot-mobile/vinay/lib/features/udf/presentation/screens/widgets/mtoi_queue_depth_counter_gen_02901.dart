// GEN-02901 — MTOI Queue Depth Counter Widget for Mobile Ops Dashboard.
// Displays the MTOI Queue depth counter using M3 Elevated Cards with inline status chips, 30-second background polling, and pull-to-refresh support. Single-column mobile layout (<600dp) with 48x48dp touch targets.

import 'dart:async';
import 'package:flutter/material.dart';

/// Mock data model representing the MTOI Queue Depth state.
class MtoiQueueDepthData {
  final int currentDepth;
  final int capacity;
  final String completionStatus; // Complete / Partial / Not Complete
  final DateTime lastUpdated;
  final String traceId;

  const MtoiQueueDepthData({
    required this.currentDepth,
    required this.capacity,
    required this.completionStatus,
    required this.lastUpdated,
    required this.traceId,
  });
}

/// Mock repository simulating sub-100ms API response latencies.
class MtoiQueueRepository {
  static int _mockCallCount = 0;

  Future<MtoiQueueDepthData> fetchQueueDepth() async {
    // Simulate network latency < 100ms
    await Future.delayed(const Duration(milliseconds: 45));
    _mockCallCount++;

    // Simulate varying queue depths
    final mockDepths = [12, 45, 78, 100, 23];
    final depth = mockDepths[_mockCallCount % mockDepths.length];
    final capacity = 100;

    String status;
    if (depth == capacity) {
      status = 'Complete';
    } else if (depth > 0) {
      status = 'Partial';
    } else {
      status = 'Not Complete';
    }

    return MtoiQueueDepthData(
      currentDepth: depth,
      capacity: capacity,
      completionStatus: status,
      lastUpdated: DateTime.now(),
      traceId: 'trace-gen-02901-${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

/// Main widget displaying the MTOI Queue Depth Counter on the engineering console dashboard.
class MtoiQueueDepthCounterGen02901 extends StatefulWidget {
  const MtoiQueueDepthCounterGen02901({super.key});

  @override
  State<MtoiQueueDepthCounterGen02901> createState() => _MtoiQueueDepthCounterGen02901State();
}

class _MtoiQueueDepthCounterGen02901State extends State<MtoiQueueDepthCounterGen02901> {
  final MtoiQueueRepository _repository = MtoiQueueRepository();
  MtoiQueueDepthData? _data;
  bool _isLoading = false;
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
      final newData = await _repository.fetchQueueDepth();
      if (mounted) {
        setState(() {
          _data = newData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch queue depth: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Color _getStatusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case 'Complete':
        return colorScheme.primary;
      case 'Partial':
        return colorScheme.tertiary;
      case 'Not Complete':
        return colorScheme.error;
      default:
        return colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: _fetchData,
      color: colorScheme.primary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // M3 responsive layout: single-column on mobile (<600dp)
          final isMobile = constraints.maxWidth < 600;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
            child: isMobile ? _buildMobileLayout(context, colorScheme, textTheme) : _buildDesktopLayout(context, colorScheme, textTheme),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context, textTheme),
        const SizedBox(height: 16),
        _buildElevatedCard(context, colorScheme, textTheme),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    // Multi-column on desktop (>=840dp)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildElevatedCard(context, colorScheme, textTheme)),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, textTheme),
              const SizedBox(height: 16),
              _buildMetadataCard(context, colorScheme, textTheme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MTOI Queue Depth',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Engineering Console Dashboard',
          style: textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildElevatedCard(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    // M3 Elevated Cards Level 2 (3dp)
    return Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isLoading && _data == null
            ? const Center(child: CircularProgressIndicator())
            : _data == null
                ? Center(child: Text('No data available', style: textTheme.bodyLarge))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Queue Depth Counter', style: textTheme.titleMedium),
                          // M3 Status Chips for health indicators
                          _buildStatusChip(context, _data!.completionStatus),
                        ],
                      ),
                      const Divider(height: 32),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              '${_data!.currentDepth} / ${_data!.capacity}',
                              style: textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(context, _data!.completionStatus),
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _data!.currentDepth / _data!.capacity,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                              backgroundColor: colorScheme.surfaceContainerLow,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getStatusColor(context, _data!.completionStatus),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 48x48dp touch targets
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showConfigBottomSheet(context),
                          icon: const Icon(Icons.settings_outlined, size: 24),
                          label: const Text('Configure Metrics'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(48, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildMetadataCard(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Telemetry Metadata', style: textTheme.titleSmall),
            const SizedBox(height: 12),
            if (_data != null) ...[
              _buildMetaRow('Trace ID', _data!.traceId, textTheme),
              _buildMetaRow('Last Updated', _formatTime(_data!.lastUpdated), textTheme),
              _buildMetaRow('Metric Name', 'Task Completion Status', textTheme),
              _buildMetaRow('Standard', 'ITIL v4 SVS', textTheme),
            ] else ..[
              Text('Loading metadata...', style: textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value, style: textTheme.bodySmall, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final color = _getStatusColor(context, status);
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(Icons.circle, size: 12, color: color),
      ),
      label: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  /// M3 Bottom Sheet for configuration inputs
  void _showConfigBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                'Queue Depth Configuration',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Floor Boundary',
                  hintText: '0.8',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Optimal Target',
                  hintText: '1.0',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Ceiling Boundary',
                  hintText: '1.0',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // M3 Snackbar for confirmations
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Configuration updated successfully.'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  child: const Text('Save Configuration'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}
