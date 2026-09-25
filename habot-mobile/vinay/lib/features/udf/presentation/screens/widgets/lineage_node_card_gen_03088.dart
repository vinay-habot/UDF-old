// GEN-03088 — Lineage Node Card with Surface Container High styling and Primary connection lines.
// Implements M3 Elevated Card (Level 2, 3dp) with status chips, 48x48dp touch targets,
// responsive single-column/multi-column layout, bottom sheet configuration, and mock telemetry data.

import 'package:flutter/material.dart';

enum ConsistencyStatus { good, average, poor }

class LineageNodeMockData {
  final String nodeId;
  final String nodeName;
  final double consistencyScore;
  final ConsistencyStatus status;
  final DateTime lastUpdated;

  const LineageNodeMockData({
    required this.nodeId,
    required this.nodeName,
    required this.consistencyScore,
    required this.status,
    required this.lastUpdated,
  });
}

final List<LineageNodeMockData> mockLineageNodes = [
  LineageNodeMockData(
    nodeId: 'TRACE-001',
    nodeName: 'Auth Service Lineage',
    consistencyScore: 96.5,
    status: ConsistencyStatus.good,
    lastUpdated: DateTime(2026, 9, 25, 10, 30),
  ),
  LineageNodeMockData(
    nodeId: 'TRACE-002',
    nodeName: 'UDF Pipeline Node',
    consistencyScore: 87.2,
    status: ConsistencyStatus.average,
    lastUpdated: DateTime(2026, 9, 25, 10, 28),
  ),
  LineageNodeMockData(
    nodeId: 'TRACE-003',
    nodeName: 'Telemetry Aggregator',
    consistencyScore: 72.0,
    status: ConsistencyStatus.poor,
    lastUpdated: DateTime(2026, 9, 25, 10, 15),
  ),
];

class LineageNodeCard extends StatelessWidget {
  final LineageNodeMockData node;
  final VoidCallback? onConfigure;

  const LineageNodeCard({
    super.key,
    required this.node,
    this.onConfigure,
  });

  Color _statusColor(BuildContext context, ConsistencyStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case ConsistencyStatus.good:
        return colorScheme.primary;
      case ConsistencyStatus.average:
        return colorScheme.tertiary;
      case ConsistencyStatus.poor:
        return colorScheme.error;
    }
  }

  String _statusLabel(ConsistencyStatus status) {
    switch (status) {
      case ConsistencyStatus.good:
        return 'Good';
      case ConsistencyStatus.average:
        return 'Average';
      case ConsistencyStatus.poor:
        return 'Poor';
    }
  }

  void _showConfigurationSheet(BuildContext context) {
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
                'Configure Node: ${node.nodeName}',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Adjust UI Design System Consistency parameters for this lineage node.',
                style: Theme.of(ctx).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (onConfigure != null) onConfigure!();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Configuration saved for ${node.nodeId}'),
                        behavior: SnackBarBehavior.floating,
                      ),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _statusColor(context, node.status);

    return Card(
      elevation: 3.0,
      surfaceTintColor: colorScheme.surfaceContainerHighest,
      color: colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: colorScheme.primary,
          width: 2.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showConfigurationSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.hub_outlined,
                  color: colorScheme.onPrimaryContainer,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      node.nodeName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'ID: ${node.nodeId} | Score: ${node.consistencyScore.toStringAsFixed(1)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
              Chip(
                label: Text(
                  _statusLabel(node.status),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: statusColor.withOpacity(0.12),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LineageNodesScreen extends StatefulWidget {
  const LineageNodesScreen({super.key});

  @override
  State<LineageNodesScreen> createState() => _LineageNodesScreenState();
}

class _LineageNodesScreenState extends State<LineageNodesScreen> {
  late List<LineageNodeMockData> _nodes;

  @override
  void initState() {
    super.initState();
    _nodes = List.from(mockLineageNodes);
  }

  int _calculateCrossAxisCount(double width) {
    if (width < 600) return 1; // Mobile: single-column
    if (width >= 840) return 3; // Desktop: multi-column
    return 2; // Tablet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lineage Nodes Console'),
        centerTitle: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              setState(() {
                _nodes = List.from(mockLineageNodes);
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data synchronized successfully.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: crossAxisCount == 1 ? 3.5 : 2.2,
              ),
              itemCount: _nodes.length,
              itemBuilder: (context, index) {
                return LineageNodeCard(
                  node: _nodes[index],
                  onConfigure: () {},
                );
              },
            ),
          );
        },
      ),
    );
  }
}