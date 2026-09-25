// GEN-02912 — Vertex AI Prompt Routing Status Card.
// Displays the completion status of routing rendered Mustache prompts to the Vertex AI target LLM provider via an M3 Elevated Card with inline status chips. Implements single-column mobile layout, 48x48dp touch targets, Material You dynamic color, and background polling every 30 seconds with pull-to-refresh support using local mock data.

import 'dart:async';
import 'package:flutter/material.dart';

enum TaskCompletionStatus {
  complete,
  partial,
  notComplete,
}

class VertexPromptRoutingEvent {
  final String traceId;
  final TaskCompletionStatus status;
  final DateTime timestamp;
  final String sessionId;
  final String description;

  const VertexPromptRoutingEvent({
    required this.traceId,
    required this.status,
    required this.timestamp,
    required this.sessionId,
    required this.description,
  });
}

class MockVertexPromptRepository {
  static const List<VertexPromptRoutingEvent> _mockEvents = [
    VertexPromptRoutingEvent(
      traceId: 'trace-001-gen-02912',
      status: TaskCompletionStatus.complete,
      timestamp: DateTime(2026, 9, 25, 10, 0),
      sessionId: 'session-eng-01',
      description: 'Route rendered Mustache prompts to the Vertex AI target LLM provider.',
    ),
    VertexPromptRoutingEvent(
      traceId: 'trace-002-gen-02912',
      status: TaskCompletionStatus.partial,
      timestamp: DateTime(2026, 9, 25, 10, 15),
      sessionId: 'session-eng-02',
      description: 'Mustache template rendering pending validation for secondary LLM endpoint.',
    ),
    VertexPromptRoutingEvent(
      traceId: 'trace-003-gen-02912',
      status: TaskCompletionStatus.notComplete,
      timestamp: DateTime(2026, 9, 25, 10, 30),
      sessionId: 'session-eng-03',
      description: 'Vertex AI target LLM provider unreachable; fallback routing initiated.',
    ),
  ];

  Future<List<VertexPromptRoutingEvent>> fetchEvents() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _mockEvents;
  }
}

class VertexPromptStatusCardGen02912 extends StatefulWidget {
  const VertexPromptStatusCardGen02912({super.key});

  @override
  State<VertexPromptStatusCardGen02912> createState() => _VertexPromptStatusCardGen02912State();
}

class _VertexPromptStatusCardGen02912State extends State<VertexPromptStatusCardGen02912> {
  final MockVertexPromptRepository _repository = MockVertexPromptRepository();
  List<VertexPromptRoutingEvent> _events = [];
  bool _isLoading = true;
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

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final events = await _repository.fetchEvents();
      if (mounted) {
        setState(() {
          _events = events;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadData();
    });
  }

  Color _getStatusColor(TaskCompletionStatus status, ColorScheme colorScheme) {
    switch (status) {
      case TaskCompletionStatus.complete:
        return colorScheme.primary;
      case TaskCompletionStatus.partial:
        return colorScheme.tertiary;
      case TaskCompletionStatus.notComplete:
        return colorScheme.error;
    }
  }

  String _getStatusLabel(TaskCompletionStatus status) {
    switch (status) {
      case TaskCompletionStatus.complete:
        return 'Complete';
      case TaskCompletionStatus.partial:
        return 'Partial';
      case TaskCompletionStatus.notComplete:
        return 'Not Complete';
    }
  }

  IconData _getStatusIcon(TaskCompletionStatus status) {
    switch (status) {
      case TaskCompletionStatus.complete:
        return Icons.check_circle_outline_rounded;
      case TaskCompletionStatus.partial:
        return Icons.timelapse_rounded;
      case TaskCompletionStatus.notComplete:
        return Icons.error_outline_rounded;
    }
  }

  void _showConfigurationBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step Configuration',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'GEN-02912: Route rendered Mustache prompts to the Vertex AI target LLM provider.',
                style: Theme.of(ctx).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Configuration saved successfully.'),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: 'DISMISS',
                            onPressed: () {},
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Apply Configuration'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return RefreshIndicator(
      onRefresh: _loadData,
      color: colorScheme.primary,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isMobile = constraints.maxWidth < 600;
          final int crossAxisCount = isMobile ? 1 : (constraints.maxWidth >= 840 ? 3 : 2);

          if (_isLoading && _events.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(48.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vertex AI Prompt Routing',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'GEN-02912 • ITIL v4 Service Value System',
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: IconButton(
                        icon: Icon(Icons.settings_outlined, color: colorScheme.onSurfaceVariant),
                        onPressed: () => _showConfigurationBottomSheet(context),
                        tooltip: 'Configure Step',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: isMobile ? 2.8 : 2.2,
                  ),
                  itemCount: _events.length,
                  itemBuilder: (BuildContext context, int index) {
                    final VertexPromptRoutingEvent event = _events[index];
                    final Color statusColor = _getStatusColor(event.status, colorScheme);

                    return Card(
                      elevation: 3.0,
                      surfaceTintColor: colorScheme.surfaceTint,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Drill-down: ${event.traceId}'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _getStatusIcon(event.status),
                                    color: statusColor,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      event.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Chip(
                                    avatar: Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: statusColor,
                                    ),
                                    label: Text(
                                      _getStatusLabel(event.status),
                                      style: textTheme.labelSmall?.copyWith(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: statusColor.withOpacity(0.1),
                                    side: BorderSide.none,
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  Text(
                                    '${event.timestamp.hour.toString().padLeft(2, '0')}:${event.timestamp.minute.toString().padLeft(2, '0')}',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Auto-refreshing every 30s • Pull down to refresh manually',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
