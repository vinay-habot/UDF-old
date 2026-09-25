// GEN-02505 — MTO Exception Backlog Widget for Admin Dashboard.
// Displays an M3 Elevated Card with status chips, RBAC enforcement metrics, and mock backlog data. Implements responsive single-column (<600dp) and multi-column (>=840dp) layouts with 48x48dp touch targets.

import 'package:flutter/material.dart';

enum _BacklogStatus { pending, processing, resolved, failed }

class _MtoExceptionItem {
  final String id;
  final String description;
  final _BacklogStatus status;
  final DateTime timestamp;

  const _MtoExceptionItem({
    required this.id,
    required this.description,
    required this.status,
    required this.timestamp,
  });
}

class _RbacMetric {
  final double enforcementRate;
  final bool isPassing;

  const _RbacMetric({required this.enforcementRate, required this.isPassing});
}

const List<_MtoExceptionItem> _mockBacklogData = [
  _MtoExceptionItem(
    id: 'EXC-1001',
    description: 'Invalid MTO routing configuration detected.',
    status: _BacklogStatus.pending,
    timestamp: null as dynamic,
  ),
  _MtoExceptionItem(
    id: 'EXC-1002',
    description: 'RBAC token mismatch on downstream service call.',
    status: _BacklogStatus.failed,
    timestamp: null as dynamic,
  ),
  _MtoExceptionItem(
    id: 'EXC-1003',
    description: 'Payload schema validation error in ingestion pipeline.',
    status: _BacklogStatus.processing,
    timestamp: null as dynamic,
  ),
  _MtoExceptionItem(
    id: 'EXC-1004',
    description: 'Timeout exceeded waiting for BigQuery partition lock.',
    status: _BacklogStatus.resolved,
    timestamp: null as dynamic,
  ),
];

const _RbacMetric _mockRbacMetric = _RbacMetric(
  enforcementRate: 0.9995,
  isPassing: true,
);

class MtoExceptionBacklogWidgetGen02505 extends StatelessWidget {
  const MtoExceptionBacklogWidgetGen02505({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isDesktop = constraints.maxWidth >= 840;
        final bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 840;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context, isDesktop),
            const SizedBox(height: 16),
            if (isDesktop)
              _buildDesktopLayout(context)
            else
              _buildMobileLayout(context, isTablet),
          ],
        );
      },
    );
  }

  Widget _buildHeaderCard(BuildContext context, bool isDesktop) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MTO Exception Backlog',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Admin Dashboard Widget • GEN-02505',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Chip(
              avatar: Icon(
                _mockRbacMetric.isPassing
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                size: 18,
                color: _mockRbacMetric.isPassing
                    ? colorScheme.primary
                    : colorScheme.error,
              ),
              label: Text(
                'RBAC: ${(_mockRbacMetric.enforcementRate * 100).toStringAsFixed(2)}%',
                style: theme.textTheme.labelLarge,
              ),
              backgroundColor: _mockRbacMetric.isPassing
                  ? colorScheme.primaryContainer.withOpacity(0.3)
                  : colorScheme.errorContainer.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildBacklogList(context),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: _buildMetricsPanel(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBacklogList(context),
        const SizedBox(height: 16),
        _buildMetricsPanel(context),
      ],
    );
  }

  Widget _buildBacklogList(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Exception Queue',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mockBacklogData.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (BuildContext context, int index) {
              final _MtoExceptionItem item = _mockBacklogData[index];
              return _buildBacklogTile(context, item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBacklogTile(BuildContext context, _MtoExceptionItem item) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final Color statusColor;
    final IconData statusIcon;
    final String statusLabel;

    switch (item.status) {
      case _BacklogStatus.pending:
        statusColor = colorScheme.tertiary;
        statusIcon = Icons.schedule;
        statusLabel = 'Pending';
        break;
      case _BacklogStatus.processing:
        statusColor = colorScheme.secondary;
        statusIcon = Icons.sync;
        statusLabel = 'Processing';
        break;
      case _BacklogStatus.resolved:
        statusColor = colorScheme.primary;
        statusIcon = Icons.check_circle;
        statusLabel = 'Resolved';
        break;
      case _BacklogStatus.failed:
        statusColor = colorScheme.error;
        statusIcon = Icons.cancel;
        statusLabel = 'Failed';
        break;
    }

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Drill-down triggered for ${item.id}'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'DISMISS',
              onPressed: () {},
            ),
          ),
        );
      },
      child: SizedBox(
        height: 72,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.id,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  statusLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsPanel(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Metrics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              context,
              label: 'RBAC Enforcement Rate',
              value: '${(_mockRbacMetric.enforcementRate * 100).toStringAsFixed(2)}%',
              target: '≥ 99.9%',
              isPassing: _mockRbacMetric.isPassing,
            ),
            const Divider(height: 24),
            _buildMetricRow(
              context,
              label: 'Total Exceptions',
              value: '${_mockBacklogData.length}',
              target: '< 10',
              isPassing: _mockBacklogData.length < 10,
            ),
            const Divider(height: 24),
            _buildMetricRow(
              context,
              label: 'Failed Items',
              value: '${_mockBacklogData.where((e) => e.status == _BacklogStatus.failed).length}',
              target: '0',
              isPassing: _mockBacklogData.where((e) => e.status == _BacklogStatus.failed).isEmpty,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () {
                  showModalBottomSheet(
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
                              'Configuration Inputs',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Polling Interval (seconds)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Configuration saved successfully.'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
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
                },
                icon: const Icon(Icons.settings, size: 20),
                label: const Text('Configure Step'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context, {
    required String label,
    required String value,
    required String target,
    required bool isPassing,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isPassing ? colorScheme.primary : colorScheme.error,
                ),
              ),
            ],
          ),
        ),
        Chip(
          label: Text(
            isPassing ? 'PASS' : 'FAIL',
            style: theme.textTheme.labelSmall?.copyWith(
              color: isPassing ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: isPassing
              ? colorScheme.primaryContainer
              : colorScheme.errorContainer,
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}