// GEN-02736 — Infrastructure Socket Listener Status Card.
// M3 Elevated Card displaying step completion state with status chips, 30s background polling, pull-to-refresh, and responsive single/multi-column layout.

import 'dart:async';
import 'package:flutter/material.dart';

enum RequirementCompleteness { complete, partial, notComplete }

class SocketListenerMockData {
  final String atomicId;
  final String globalRefId;
  final String action;
  final RequirementCompleteness completeness;
  final DateTime timestamp;
  final int sequenceOrder;
  final String assignedTeam;

  const SocketListenerMockData({
    required this.atomicId,
    required this.globalRefId,
    required this.action,
    required this.completeness,
    required this.timestamp,
    required this.sequenceOrder,
    required this.assignedTeam,
  });
}

final List<SocketListenerMockData> mockSocketListenerSteps = [
  SocketListenerMockData(
    atomicId: 'GEN-02736',
    globalRefId: 'GEN-02736',
    action: 'Commit the Infrastructure Socket Listener Byte to the Core Engineering Communications Library.',
    completeness: RequirementCompleteness.complete,
    timestamp: DateTime(2026, 9, 25, 10, 30),
    sequenceOrder: 19445,
    assignedTeam: 'DEA',
  ),
  SocketListenerMockData(
    atomicId: 'GEN-02735',
    globalRefId: 'GEN-02735',
    action: 'Prior foundational step configuration for socket listener.',
    completeness: RequirementCompleteness.partial,
    timestamp: DateTime(2026, 9, 25, 9, 15),
    sequenceOrder: 19444,
    assignedTeam: 'DEA',
  ),
];

class SocketListenerStatusCard extends StatefulWidget {
  const SocketListenerStatusCard({super.key});

  @override
  State<SocketListenerStatusCard> createState() => _SocketListenerStatusCardState();
}

class _SocketListenerStatusCardState extends State<SocketListenerStatusCard> {
  late List<SocketListenerMockData> _steps;
  Timer? _pollingTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _steps = List.from(mockSocketListenerSteps);
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchLatestData();
    });
  }

  Future<void> _fetchLatestData() async {
    if (!mounted) return;
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _steps = List.from(mockSocketListenerSteps);
      _isRefreshing = false;
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Color _statusColor(RequirementCompleteness status, ColorScheme cs) {
    switch (status) {
      case RequirementCompleteness.complete:
        return cs.primary;
      case RequirementCompleteness.partial:
        return cs.tertiary;
      case RequirementCompleteness.notComplete:
        return cs.error;
    }
  }

  String _statusLabel(RequirementCompleteness status) {
    switch (status) {
      case RequirementCompleteness.complete:
        return 'Complete';
      case RequirementCompleteness.partial:
        return 'Partial';
      case RequirementCompleteness.notComplete:
        return 'Not Complete';
    }
  }

  void _showConfigBottomSheet(BuildContext context, SocketListenerMockData step) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Configuration: ${step.atomicId}', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text(step.action, style: Theme.of(ctx).textTheme.bodyMedium),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${step.atomicId} configuration saved.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Save Configuration'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepCard(BuildContext context, SocketListenerMockData step) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showConfigBottomSheet(context, step),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      step.atomicId,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Chip(
                    avatar: Icon(Icons.circle, size: 12, color: _statusColor(step.completeness, cs)),
                    label: Text(_statusLabel(step.completeness)),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(step.action, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.group, size: 16, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(step.assignedTeam, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                  const Spacer(),
                  Icon(Icons.access_time, size: 16, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    '${step.timestamp.hour}:${step.timestamp.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 840;
        return RefreshIndicator(
          onRefresh: _fetchLatestData,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text('Engineering Console', style: Theme.of(context).textTheme.headlineSmall),
                      const Spacer(),
                      if (_isRefreshing)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),
              ),
              if (isDesktop)
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2.2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildStepCard(context, _steps[index]),
                      childCount: _steps.length,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildStepCard(context, _steps[index]),
                      ),
                      childCount: _steps.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}