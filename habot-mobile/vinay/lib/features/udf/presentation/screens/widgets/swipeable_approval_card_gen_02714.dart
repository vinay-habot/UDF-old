// GEN-02714 — Swipeable Approval Card for Infrastructure Actions.
// Implements a Material 3 swipeable card allowing stakeholders to approve infrastructure actions with status chips, dynamic color, and mock data validation.

import 'package:flutter/material.dart';

enum ApprovalStatus { pending, approved, failed }

class InfrastructureAction {
  final String id;
  final String title;
  final String description;
  final String traceId;
  final DateTime timestamp;
  ApprovalStatus status;

  InfrastructureAction({
    required this.id,
    required this.title,
    required this.description,
    required this.traceId,
    required this.timestamp,
    this.status = ApprovalStatus.pending,
  });
}

class MockApprovalRepository {
  static final List<InfrastructureAction> actions = [
    InfrastructureAction(
      id: 'ACT-001',
      title: 'Deploy Database Migration',
      description: 'Execute schema update v2.4.1 on production cluster.',
      traceId: 'trace_gen_02714_001',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    InfrastructureAction(
      id: 'ACT-002',
      title: 'Scale Compute Nodes',
      description: 'Increase worker nodes from 4 to 8 for peak traffic.',
      traceId: 'trace_gen_02714_002',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  static Future<bool> approveAction(String actionId) async {
    await Future.delayed(const Duration(milliseconds: 80)); // Sub-100ms latency simulation
    final action = actions.firstWhere((a) => a.id == actionId);
    action.status = ApprovalStatus.approved;
    return true;
  }
}

class SwipeableApprovalCardGen02714 extends StatefulWidget {
  const SwipeableApprovalCardGen02714({super.key});

  @override
  State<SwipeableApprovalCardGen02714> createState() => _SwipeableApprovalCardGen02714State();
}

class _SwipeableApprovalCardGen02714State extends State<SwipeableApprovalCardGen02714> {
  late List<InfrastructureAction> _actions;

  @override
  void initState() {
    super.initState();
    _actions = List.from(MockApprovalRepository.actions);
  }

  Color _getStatusColor(ApprovalStatus status, ColorScheme colorScheme) {
    switch (status) {
      case ApprovalStatus.pending:
        return colorScheme.tertiary;
      case ApprovalStatus.approved:
        return colorScheme.primary;
      case ApprovalStatus.failed:
        return colorScheme.error;
    }
  }

  String _getStatusLabel(ApprovalStatus status) {
    switch (status) {
      case ApprovalStatus.pending:
        return 'Pending';
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.failed:
        return 'Failed';
    }
  }

  void _handleApprove(InfrastructureAction action) async {
    final success = await MockApprovalRepository.approveAction(action.id);
    if (!mounted) return;
    setState(() {
      final index = _actions.indexWhere((a) => a.id == action.id);
      if (index != -1) {
        _actions[index].status = success ? ApprovalStatus.approved : ApprovalStatus.failed;
      }
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Action ${action.id} approved successfully.'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _actions.length,
      itemBuilder: (context, index) {
        final action = _actions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Dismissible(
            key: Key(action.id),
            direction: action.status == ApprovalStatus.pending
                ? DismissDirection.endToStart
                : DismissDirection.none,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24.0),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: colorScheme.onPrimaryContainer,
                size: 32.0,
              ),
            ),
            confirmDismiss: (direction) async {
              _handleApprove(action);
              return false; // Keep card in list, update state instead
            },
            child: Card(
              elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
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
                            action.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Chip(
                          label: Text(
                            _getStatusLabel(action.status),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                          backgroundColor: _getStatusColor(action.status, colorScheme),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      action.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Icon(Icons.tag, size: 16.0, color: colorScheme.outline),
                        const SizedBox(width: 4.0),
                        Text(
                          action.traceId,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: colorScheme.outline,
                              ),
                        ),
                        const Spacer(),
                        if (action.status == ApprovalStatus.pending)
                          SizedBox(
                            height: 48.0, // 48x48dp touch targets
                            width: 48.0,
                            child: IconButton(
                              onPressed: () => _handleApprove(action),
                              icon: Icon(
                                Icons.swipe_left,
                                color: colorScheme.primary,
                              ),
                              tooltip: 'Swipe or tap to approve',
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
