// GEN-03209 — UI Grouping Sections for Daily Planned and Finished Tasks.
// Implements M3 Elevated Cards with visual separation between daily planned tasks and finished tasks, following WCAG 2.2 guidelines and responsive layout constraints.

import 'package:flutter/material.dart';

enum TaskStatus { planned, finished }

class TaskItem {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime timestamp;

  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.timestamp,
  });
}

class MockTaskRepository {
  static List<TaskItem> getTasks() {
    return [
      TaskItem(
        id: 'task_001',
        title: 'Review Architecture Blueprint',
        description: 'Validate EC headers and single-verb function naming.',
        status: TaskStatus.planned,
        timestamp: DateTime(2026, 9, 25, 9, 0),
      ),
      TaskItem(
        id: 'task_002',
        title: 'Configure BigQuery Streaming',
        description: 'Set up event streaming partitioned by event_date.',
        status: TaskStatus.planned,
        timestamp: DateTime(2026, 9, 25, 10, 30),
      ),
      TaskItem(
        id: 'task_003',
        title: 'Setup CI/CD Pipeline Gates',
        description: 'Ensure deployment blocks if any validation gate fails.',
        status: TaskStatus.finished,
        timestamp: DateTime(2026, 9, 24, 16, 0),
      ),
      TaskItem(
        id: 'task_004',
        title: 'Implement Liveness Handshake',
        description: 'Automated 30-second health check monitoring.',
        status: TaskStatus.finished,
        timestamp: DateTime(2026, 9, 24, 17, 45),
      ),
    ];
  }
}

class TaskGroupingSection extends StatelessWidget {
  const TaskGroupingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = MockTaskRepository.getTasks();
    final plannedTasks = tasks.where((t) => t.status == TaskStatus.planned).toList();
    final finishedTasks = tasks.where((t) => t.status == TaskStatus.finished).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildSectionHeader(context, 'Daily Planned Tasks', plannedTasks.length),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _TaskCard(task: plannedTasks[index]),
              ),
              childCount: plannedTasks.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildVisualSeparator(context),
        ),
        SliverToBoxAdapter(
          child: _buildSectionHeader(context, 'Finished Tasks', finishedTasks.length),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _TaskCard(task: finishedTasks[index]),
              ),
              childCount: finishedTasks.length,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24.0)),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      header: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Text(
                '$count',
                style: textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualSeparator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 2.0,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 20.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 2.0,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskItem task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFinished = task.status == TaskStatus.finished;

    return Semantics(
      label: '${task.title}, ${isFinished ? "Completed" : "Planned"}',
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Deep-link drill-down for ${task.id}'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            );
          },
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
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: isFinished ? TextDecoration.lineThrough : null,
                          color: isFinished ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    _buildStatusChip(context, isFinished),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  task.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    _formatTimestamp(task.timestamp),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, bool isFinished) {
    return Chip(
      avatar: Icon(
        isFinished ? Icons.check_circle : Icons.schedule,
        size: 18.0,
        color: isFinished
            ? Theme.of(context).colorScheme.onTertiaryContainer
            : Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      label: Text(
        isFinished ? 'Finished' : 'Planned',
        style: Theme.of(context).textTheme.labelMedium,
      ),
      backgroundColor: isFinished
          ? Theme.of(context).colorScheme.tertiaryContainer
          : Theme.of(context).colorScheme.primaryContainer,
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  String _formatTimestamp(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} $hour:$minute';
  }
}
