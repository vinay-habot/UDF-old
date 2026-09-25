// GEN-03275 — Supervisor Exception Workflow Console Screen.
// Connects supervisor interface controls to backend exception workflow triggers with M3 Elevated Cards, status chips, 30s polling, and pull-to-refresh.

import 'dart:async';
import 'package:flutter/material.dart';

enum WorkflowStatus { complete, pending, failed }

class WorkflowTriggerModel {
  final String traceId;
  final String name;
  final WorkflowStatus status;
  final int latencyMs;
  final DateTime timestamp;

  const WorkflowTriggerModel({
    required this.traceId,
    required this.name,
    required this.status,
    required this.latencyMs,
    required this.timestamp,
  });
}

class MockWorkflowRepository {
  static const List<WorkflowTriggerModel> mockTriggers = [
    WorkflowTriggerModel(
      traceId: 'trace-001-gen-03275',
      name: 'Exception Workflow Alpha',
      status: WorkflowStatus.complete,
      latencyMs: 18,
      timestamp: DateTime(2026, 9, 25, 10, 0),
    ),
    WorkflowTriggerModel(
      traceId: 'trace-002-gen-03275',
      name: 'Exception Workflow Beta',
      status: WorkflowStatus.pending,
      latencyMs: 45,
      timestamp: DateTime(2026, 9, 25, 10, 1),
    ),
    WorkflowTriggerModel(
      traceId: 'trace-003-gen-03275',
      name: 'Exception Workflow Gamma',
      status: WorkflowStatus.failed,
      latencyMs: 210,
      timestamp: DateTime(2026, 9, 25, 10, 2),
    ),
  ];

  Future<List<WorkflowTriggerModel>> fetchTriggers() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return mockTriggers;
  }
}

class SupervisorExceptionWorkflowScreen extends StatefulWidget {
  const SupervisorExceptionWorkflowScreen({super.key});

  @override
  State<SupervisorExceptionWorkflowScreen> createState() => _SupervisorExceptionWorkflowScreenState();
}

class _SupervisorExceptionWorkflowScreenState extends State<SupervisorExceptionWorkflowScreen> {
  final MockWorkflowRepository _repository = MockWorkflowRepository();
  List<WorkflowTriggerModel> _triggers = [];
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
    try {
      final data = await _repository.fetchTriggers();
      if (mounted) {
        setState(() {
          _triggers = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showConfigBottomSheet(WorkflowTriggerModel trigger) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Configuration: ${trigger.name}', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text('Trace ID: ${trigger.traceId}'),
              const SizedBox(height: 8),
              Text('Latency: ${trigger.latencyMs}ms'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configuration saved successfully.')),
                    );
                  },
                  child: const Text('Apply Configuration'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(WorkflowStatus status, ThemeData theme) {
    switch (status) {
      case WorkflowStatus.complete:
        return theme.colorScheme.primary;
      case WorkflowStatus.pending:
        return theme.colorScheme.tertiary;
      case WorkflowStatus.failed:
        return theme.colorScheme.error;
    }
  }

  String _getStatusLabel(WorkflowStatus status) {
    switch (status) {
      case WorkflowStatus.complete:
        return 'Complete';
      case WorkflowStatus.pending:
        return 'Pending';
      case WorkflowStatus.failed:
        return 'Failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor Exception Workflow'),
        centerTitle: false,
      ),
      body: _isLoading && _triggers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 840;
                  final crossAxisCount = isDesktop ? 2 : 1;

                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: isDesktop ? 3.0 : 2.5,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: _triggers.length,
                    itemBuilder: (context, index) {
                      final trigger = _triggers[index];
                      return Card(
                        elevation: 3.0,
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => _showConfigBottomSheet(trigger),
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
                                        trigger.name,
                                        style: theme.textTheme.titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Chip(
                                      label: Text(
                                        _getStatusLabel(trigger.status),
                                        style: TextStyle(
                                          color: _getStatusColor(trigger.status, theme),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      backgroundColor: _getStatusColor(trigger.status, theme).withOpacity(0.1),
                                      side: BorderSide.none,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text('Trace ID: ${trigger.traceId}', style: theme.textTheme.bodySmall),
                                const SizedBox(height: 8),
                                Text('Latency: ${trigger.latencyMs}ms', style: theme.textTheme.bodyMedium),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'Updated: ${trigger.timestamp.hour}:${trigger.timestamp.minute.toString().padLeft(2, '0')}',
                                    style: theme.textTheme.labelSmall,
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
            ),
    );
  }
}
