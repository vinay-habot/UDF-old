// GEN-03376 — Mobile Learning Dashboard displaying mandatory courses, due dates, and learning paths.
// Implements M3 Elevated Cards (Level 2), Status Chips, responsive single-column/multi-column layout, pull-to-refresh, and 30s background polling with local mock data.

import 'dart:async';
import 'package:flutter/material.dart';

enum CourseStatus { completed, inProgress, overdue, notStarted }

class MockCourse {
  final String id;
  final String title;
  final String path;
  final DateTime dueDate;
  final CourseStatus status;
  final bool isMandatory;

  const MockCourse({
    required this.id,
    required this.title,
    required this.path,
    required this.dueDate,
    required this.status,
    required this.isMandatory,
  });
}

final List<MockCourse> _mockCourses = [
  MockCourse(
    id: 'CRS-001',
    title: 'Information Security Fundamentals',
    path: 'Security Compliance Path',
    dueDate: DateTime(2026, 10, 15),
    status: CourseStatus.inProgress,
    isMandatory: true,
  ),
  MockCourse(
    id: 'CRS-002',
    title: 'Workplace Ethics & Conduct',
    path: 'Corporate Standards Path',
    dueDate: DateTime(2026, 9, 20),
    status: CourseStatus.overdue,
    isMandatory: true,
  ),
  MockCourse(
    id: 'CRS-003',
    title: 'Flutter Advanced State Management',
    path: 'Mobile Engineering Path',
    dueDate: DateTime(2026, 11, 1),
    status: CourseStatus.notStarted,
    isMandatory: false,
  ),
  MockCourse(
    id: 'CRS-004',
    title: 'Data Privacy Regulations',
    path: 'Security Compliance Path',
    dueDate: DateTime(2026, 8, 30),
    status: CourseStatus.completed,
    isMandatory: true,
  ),
];

class LearningDashboardGen03376 extends StatefulWidget {
  const LearningDashboardGen03376({super.key});

  @override
  State<LearningDashboardGen03376> createState() => _LearningDashboardGen03376State();
}

class _LearningDashboardGen03376State extends State<LearningDashboardGen03376> {
  Timer? _pollingTimer;
  late List<MockCourse> _courses;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _courses = List.from(_mockCourses);
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _syncData();
    });
  }

  Future<void> _syncData() async {
    if (!mounted) return;
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _courses = List.from(_mockCourses);
        _isRefreshing = false;
      });
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Color _statusColor(CourseStatus status, ColorScheme cs) {
    switch (status) {
      case CourseStatus.completed:
        return cs.primary;
      case CourseStatus.inProgress:
        return cs.tertiary;
      case CourseStatus.overdue:
        return cs.error;
      case CourseStatus.notStarted:
        return cs.outline;
    }
  }

  String _statusLabel(CourseStatus status) {
    switch (status) {
      case CourseStatus.completed:
        return 'Completed';
      case CourseStatus.inProgress:
        return 'In Progress';
      case CourseStatus.overdue:
        return 'Overdue';
      case CourseStatus.notStarted:
        return 'Not Started';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Manual Sync',
            onPressed: () {
              _syncData().then((_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Dashboard synchronized successfully.'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _syncData,
        color: cs.primary,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 840;
            final crossAxisCount = isDesktop ? 2 : 1;

            if (_isRefreshing && _courses.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: isDesktop ? 2.8 : 2.2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final course = _courses[index];
                        return _buildCourseCard(course, theme, cs);
                      },
                      childCount: _courses.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCourseCard(MockCourse course, ThemeData theme, ColorScheme cs) {
    final statusColor = _statusColor(course.status, cs);
    final formattedDate = '${course.dueDate.year}-${course.dueDate.month.toString().padLeft(2, '0')}-${course.dueDate.day.toString().padLeft(2, '0')}';

    return Card(
      elevation: 3,
      surfaceTintColor: cs.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            useSafeArea: true,
            showDragHandle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            builder: (ctx) => Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Path: ${course.path}', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text('Due Date: $formattedDate', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close Details'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (course.isMandatory)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: cs.errorContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Mandatory',
                        style: theme.textTheme.labelSmall?.copyWith(color: cs.onErrorContainer),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                course.path,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Due: $formattedDate',
                    style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  Chip(
                    label: Text(_statusLabel(course.status)),
                    backgroundColor: statusColor.withOpacity(0.12),
                    labelStyle: theme.textTheme.labelMedium?.copyWith(color: statusColor, fontWeight: FontWeight.w600),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}