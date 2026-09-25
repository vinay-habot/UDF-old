// GEN-03011 — Pre/Post Action Approval Gate Status Card.
// Displays governance sign-off completion rate and approval gate configuration using M3 Elevated Cards, status chips, and responsive layout with mock data.

import 'dart:async';
import 'package:flutter/material.dart';

enum ApprovalGateType { preAction, postAction }

enum CompletionStatus { complete, partial, notComplete }

class ToolActionGate {
  final String id;
  final String name;
  final ApprovalGateType gateType;
  final CompletionStatus status;
  final DateTime lastUpdated;

  const ToolActionGate({
    required this.id,
    required this.name,
    required this.gateType,
    required this.status,
    required this.lastUpdated,
  });
}

class MockApprovalGateRepository {
  static const List<ToolActionGate> gates = [
    ToolActionGate(
      id: 'gate-001',
      name: 'Deploy to Production',
      gateType: ApprovalGateType.preAction,
      status: CompletionStatus.complete,
      lastUpdated: DateTime(2026, 9, 25, 10, 0),
    ),
    ToolActionGate(
      id: 'gate-002',
      name: 'Database Migration',
      gateType: ApprovalGateType.preAction,
      status: CompletionStatus.partial,
      lastUpdated: DateTime(2026, 9, 25, 10, 15),
    ),
    ToolActionGate(
      id: 'gate-003',
      name: 'Config Update',
      gateType: ApprovalGateType.postAction,
      status: CompletionStatus.notComplete,
      lastUpdated: DateTime(2026, 9, 25, 10, 30),
    ),
    ToolActionGate(
      id: 'gate-004',
      name: 'Feature Flag Toggle',
      gateType: ApprovalGateType.postAction,
      status: CompletionStatus.complete,
      lastUpdated: DateTime(2026, 9, 25, 10, 45),
    ),
  ];

  static double getGovernanceSignOffRate() {
    final completed = gates.where((g) => g.status == CompletionStatus.complete).length;
    return (completed / gates.length) * 100.0;
  }
}

class ApprovalGateCardGen03011 extends StatefulWidget {
  const ApprovalGateCardGen03011({super.key});

  @override
  State<ApprovalGateCardGen03011> createState() => _ApprovalGateCardGen03011State();
}

class _ApprovalGateCardGen03011State extends State<ApprovalGateCardGen03011> {
  late List<ToolActionGate> _gates;
  late double _completionRate;
  Timer? _pollingTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startPolling();
  }

  void _loadData() {
    _gates = MockApprovalGateRepository.gates;
    _completionRate = MockApprovalGateRepository.getGovernanceSignOffRate();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() => _loadData());
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _loadData();
        _isRefreshing = false;
      });
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Color _statusColor(BuildContext context, CompletionStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case CompletionStatus.complete:
        return colorScheme.primary;
      case CompletionStatus.partial:
        return colorScheme.tertiary;
      case CompletionStatus.notComplete:
        return colorScheme.error;
    }
  }

  String _statusLabel(CompletionStatus status) {
    switch (status) {
      case CompletionStatus.complete:
        return 'Complete';
      case CompletionStatus.partial:
        return 'Partial';
      case CompletionStatus.notComplete:
        return 'Not Complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final crossAxisCount = isMobile ? 1 : (constraints.maxWidth >= 840 ? 2 : 1);

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildKpiHeader(context, textTheme, colorScheme),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: isMobile ? 2.8 : 3.2,
                  ),
                  itemCount: _gates.length,
                  itemBuilder: (context, index) => _buildGateItem(context, _gates[index]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKpiHeader(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    final meetsFloor = _completionRate >= 90.0;

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Governance Sign-off Completion Rate',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_completionRate.toStringAsFixed(1)}%',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: meetsFloor ? colorScheme.primary : colorScheme.error,
                  ),
                ),
                Chip(
                  avatar: Icon(
                    meetsFloor ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                    size: 18,
                    color: meetsFloor ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
                  ),
                  label: Text(meetsFloor ? 'Compliant' : 'Below Floor (90%)'),
                  backgroundColor: meetsFloor ? colorScheme.primaryContainer : colorScheme.errorContainer,
                  labelStyle: TextStyle(
                    color: meetsFloor ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'ITIL v4 Change Enablement Practice',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGateItem(BuildContext context, ToolActionGate gate) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _statusColor(context, gate.status);

    return Semantics(
      label: '${gate.name}, ${gate.gateType == ApprovalGateType.preAction ? 'Pre-Action' : 'Post-Action'} approval gate, status: ${_statusLabel(gate.status)}',
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: InkWell(
          onTap: () => _showBottomSheet(context, gate),
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        gate.name,
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: gate.gateType == ApprovalGateType.preAction
                            ? colorScheme.secondaryContainer
                            : colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        gate.gateType == ApprovalGateType.preAction ? 'PRE' : 'POST',
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: gate.gateType == ApprovalGateType.preAction
                              ? colorScheme.onSecondaryContainer
                              : colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      visualDensity: VisualDensity.compact,
                      backgroundColor: statusColor.withOpacity(0.12),
                      label: Text(
                        _statusLabel(gate.status),
                        style: textTheme.labelMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${gate.lastUpdated.hour}:${gate.lastUpdated.minute.toString().padLeft(2, '0')}',
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, ToolActionGate gate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                gate.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Gate Type'),
                subtitle: Text(gate.gateType == ApprovalGateType.preAction ? 'Pre-Action Approval' : 'Post-Action Review'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Current Status'),
                subtitle: Text(_statusLabel(gate.status)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Last Updated'),
                subtitle: Text(gate.lastUpdated.toString()),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Configuration saved for ${gate.name}'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                    );
                  },
                  child: const Text('Confirm Configuration'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
