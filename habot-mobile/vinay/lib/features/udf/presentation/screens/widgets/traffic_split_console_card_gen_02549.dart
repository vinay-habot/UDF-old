// GEN-02549 — Traffic Split Engineering Console Card.
// Displays hard-coded traffic splits with M3 Elevated Card, status chips, and background polling for mobile engineering console.

import 'dart:async';
import 'package:flutter/material.dart';

enum StepCompletionStatus { complete, partial, notComplete }

class TrafficSplitConfig {
  final String variantId;
  final String variantName;
  final double allocationPercentage;
  final int minimumSampleSize;
  final StepCompletionStatus status;

  const TrafficSplitConfig({
    required this.variantId,
    required this.variantName,
    required this.allocationPercentage,
    required this.minimumSampleSize,
    required this.status,
  });
}

class MockTrafficSplitRepository {
  static const List<TrafficSplitConfig> hardcodedSplits = [
    TrafficSplitConfig(
      variantId: 'VAR-A-001',
      variantName: 'Control Group',
      allocationPercentage: 50.0,
      minimumSampleSize: 10000,
      status: StepCompletionStatus.complete,
    ),
    TrafficSplitConfig(
      variantId: 'VAR-B-002',
      variantName: 'Treatment Alpha',
      allocationPercentage: 25.0,
      minimumSampleSize: 5000,
      status: StepCompletionStatus.complete,
    ),
    TrafficSplitConfig(
      variantId: 'VAR-C-003',
      variantName: 'Treatment Beta',
      allocationPercentage: 25.0,
      minimumSampleSize: 5000,
      status: StepCompletionStatus.partial,
    ),
  ];

  Future<List<TrafficSplitConfig>> fetchSplits() async {
    await Future.delayed(const Duration(milliseconds: 80));
    return hardcodedSplits;
  }
}

class TrafficSplitConsoleCard extends StatefulWidget {
  const TrafficSplitConsoleCard({super.key});

  @override
  State<TrafficSplitConsoleCard> createState() => _TrafficSplitConsoleCardState();
}

class _TrafficSplitConsoleCardState extends State<TrafficSplitConsoleCard> {
  final MockTrafficSplitRepository _repository = MockTrafficSplitRepository();
  List<TrafficSplitConfig> _splits = [];
  bool _isLoading = true;
  Timer? _pollingTimer;
  DateTime? _lastSynced;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    final data = await _repository.fetchSplits();
    if (mounted) {
      setState(() {
        _splits = data;
        _isLoading = false;
        _lastSynced = DateTime.now();
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await _loadData();
  }

  Color _statusColor(StepCompletionStatus status, ColorScheme colorScheme) {
    switch (status) {
      case StepCompletionStatus.complete:
        return colorScheme.primary;
      case StepCompletionStatus.partial:
        return colorScheme.tertiary;
      case StepCompletionStatus.notComplete:
        return colorScheme.error;
    }
  }

  String _statusLabel(StepCompletionStatus status) {
    switch (status) {
      case StepCompletionStatus.complete:
        return 'Complete';
      case StepCompletionStatus.partial:
        return 'Partial';
      case StepCompletionStatus.notComplete:
        return 'Not Complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDesktop = MediaQuery.sizeOf(context).width >= 840;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Card(
        elevation: 3.0,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Traffic Splits (GEN-02549)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Chip(
                    avatar: Icon(
                      _isLoading ? Icons.sync : Icons.check_circle,
                      size: 18,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    label: Text(
                      _isLoading
                          ? 'Syncing...'
                          : 'Live ${_lastSynced != null ? "• ${_lastSynced!.minute}:${_lastSynced!.second.toString().padLeft(2, '0')}" : ""}',
                      style: theme.textTheme.labelSmall,
                    ),
                    backgroundColor: colorScheme.secondaryContainer,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_isLoading && _splits.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                isDesktop
                    ? _buildMultiColumnLayout(theme, colorScheme)
                    : _buildSingleColumnLayout(theme, colorScheme),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Process Completion Rate', style: theme.textTheme.bodyMedium),
                    Text(
                      '${(_calculateCompletionRate() * 100).toStringAsFixed(1)}%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleColumnLayout(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: _splits.map((split) => _buildSplitTile(split, theme, colorScheme)).toList(),
    );
  }

  Widget _buildMultiColumnLayout(ThemeData theme, ColorScheme colorScheme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        childAspectRatio: 3.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _splits.length,
      itemBuilder: (context, index) => _buildSplitTile(_splits[index], theme, colorScheme),
    );
  }

  Widget _buildSplitTile(TrafficSplitConfig split, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _showBottomSheet(context, split),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(split.variantName, style: theme.textTheme.bodyLarge),
                    Text('ID: ${split.variantId}', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  '${split.allocationPercentage.toStringAsFixed(0)}%',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Chip(
                    label: Text(_statusLabel(split.status), style: theme.textTheme.labelSmall),
                    backgroundColor: _statusColor(split.status, colorScheme).withOpacity(0.15),
                    labelStyle: TextStyle(color: _statusColor(split.status, colorScheme)),
                    side: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateCompletionRate() {
    if (_splits.isEmpty) return 0.0;
    final completed = _splits.where((s) => s.status == StepCompletionStatus.complete).length;
    return completed / _splits.length;
  }

  void _showBottomSheet(BuildContext context, TrafficSplitConfig split) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Variant Configuration', style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                _infoRow('Variant Name', split.variantName, theme),
                _infoRow('Allocation', '${split.allocationPercentage}%', theme),
                _infoRow('Min Sample Size', split.minimumSampleSize.toString(), theme),
                _infoRow('Status', _statusLabel(split.status), theme),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Configuration acknowledged. Read-only mode active.'),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(label: 'OK', onPressed: () {}),
                        ),
                      );
                    },
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}