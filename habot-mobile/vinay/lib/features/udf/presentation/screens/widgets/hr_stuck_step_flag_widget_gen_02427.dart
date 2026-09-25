// GEN-02427 — HR Stuck Step Flag Monitor Widget.
// Automatically flags HR if a user remains stuck on a step for >24 hours (Self-Chasing). Implements M3 Elevated Cards, Status Chips, 30s polling, and pull-to-refresh.

import 'dart:async';
import 'package:flutter/material.dart';

enum StepCompletionStatus { complete, partial, notComplete }

class MockStepProgressData {
  final String userId;
  final String sessionId;
  final String stepId;
  final DateTime enteredAt;
  final StepCompletionStatus status;
  final double processCompletionRate;

  const MockStepProgressData({
    required this.userId,
    required this.sessionId,
    required this.stepId,
    required this.enteredAt,
    required this.status,
    required this.processCompletionRate,
  });
}

class MockHrFlagRepository {
  static List<MockStepProgressData> fetchStuckSteps() {
    final now = DateTime.now();
    return [
      MockStepProgressData(
        userId: 'USR-001',
        sessionId: 'SESS-A1',
        stepId: 'STEP-10',
        enteredAt: now.subtract(const Duration(hours: 26)),
        status: StepCompletionStatus.notComplete,
        processCompletionRate: 0.0,
      ),
      MockStepProgressData(
        userId: 'USR-002',
        sessionId: 'SESS-B2',
        stepId: 'STEP-14',
        enteredAt: now.subtract(const Duration(hours: 30)),
        status: StepCompletionStatus.partial,
        processCompletionRate: 0.45,
      ),
      MockStepProgressData(
        userId: 'USR-003',
        sessionId: 'SESS-C3',
        stepId: 'STEP-22',
        enteredAt: now.subtract(const Duration(hours: 12)),
        status: StepCompletionStatus.complete,
        processCompletionRate: 1.0,
      ),
    ];
  }

  static Future<bool> flagHrForUser(String userId, String stepId) async {
    await Future.delayed(const Duration(milliseconds: 80));
    return true;
  }
}

class HrStuckStepFlagWidget extends StatefulWidget {
  const HrStuckStepFlagWidget({super.key});

  @override
  State<HrStuckStepFlagWidget> createState() => _HrStuckStepFlagWidgetState();
}

class _HrStuckStepFlagWidgetState extends State<HrStuckStepFlagWidget> {
  List<MockStepProgressData> _steps = [];
  bool _isLoading = false;
  Timer? _pollingTimer;

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
      if (mounted) _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final data = MockHrFlagRepository.fetchStuckSteps();
    if (!mounted) return;
    setState(() {
      _steps = data;
      _isLoading = false;
    });
    await _evaluateAndFlag(data);
  }

  Future<void> _evaluateAndFlag(List<MockStepProgressData> steps) async {
    final now = DateTime.now();
    for (final step in steps) {
      final diff = now.difference(step.enteredAt);
      if (diff.inHours > 24 && step.status != StepCompletionStatus.complete) {
        final flagged = await MockHrFlagRepository.flagHrForUser(step.userId, step.stepId);
        if (flagged && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('HR flagged for ${step.userId} stuck on ${step.stepId}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Color _statusColor(StepCompletionStatus status, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (status) {
      case StepCompletionStatus.complete:
        return cs.primary;
      case StepCompletionStatus.partial:
        return cs.tertiary;
      case StepCompletionStatus.notComplete:
        return cs.error;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 840;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: isDesktop
                ? Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: _steps.map((s) => SizedBox(width: 400, child: _buildCard(s))).toList(),
                  )
                : Column(
                    children: _steps.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildCard(s),
                    )).toList(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCard(MockStepProgressData step) {
    final now = DateTime.now();
    final hoursStuck = now.difference(step.enteredAt).inHours;
    final isStuckOver24 = hoursStuck > 24 && step.status != StepCompletionStatus.complete;

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                    'Step: ${step.stepId}',
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(
                    _statusLabel(step.status),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: _statusColor(step.status, context),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('User ID: ${step.userId}', style: Theme.of(context).textTheme.bodyMedium),
            Text('Session: ${step.sessionId}', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: step.processCompletionRate.clamp(0.0, 1.0),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 4),
            Text(
              'Process Completion Rate: ${(step.processCompletionRate * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Time on step: $hoursStuck hours',
              style: TextStyle(
                color: isStuckOver24 ? Theme.of(context).colorScheme.error : null,
                fontWeight: isStuckOver24 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isStuckOver24) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    final success = await MockHrFlagRepository.flagHrForUser(step.userId, step.stepId);
                    if (success && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('HR successfully flagged.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.warning_amber_rounded, size: 20),
                  label: const Text('Flag HR (Self-Chasing)'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}