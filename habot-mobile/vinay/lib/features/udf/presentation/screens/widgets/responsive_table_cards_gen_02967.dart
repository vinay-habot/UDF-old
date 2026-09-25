// GEN-02967 — Responsive Extracted Table Renderer.
// Renders extracted tables on mobile as responsive card stacks or horizontally scrollable data grids using M3 Elevated Cards, 48x48dp touch targets, and adaptive layouts.

import 'package:flutter/material.dart';

// Mock Data Models
class ExtractedTableRow {
  final String id;
  final Map<String, String> columns;
  final String status;

  const ExtractedTableRow({
    required this.id,
    required this.columns,
    required this.status,
  });
}

const List<ExtractedTableRow> _mockTableData = [
  ExtractedTableRow(
    id: 'ROW-001',
    columns: {'Name': 'Alpha Component', 'Version': '1.0.4', 'Owner': 'Eng Team A'},
    status: 'Completed',
  ),
  ExtractedTableRow(
    id: 'ROW-002',
    columns: {'Name': 'Beta Service', 'Version': '2.3.1', 'Owner': 'Eng Team B'},
    status: 'In Progress',
  ),
  ExtractedTableRow(
    id: 'ROW-003',
    columns: {'Name': 'Gamma Module', 'Version': '0.9.0', 'Owner': 'Eng Team C'},
    status: 'Pending',
  ),
  ExtractedTableRow(
    id: 'ROW-004',
    columns: {'Name': 'Delta Pipeline', 'Version': '3.1.2', 'Owner': 'DevOps'},
    status: 'Failed',
  ),
];

class ResponsiveTableCardsGen02967 extends StatefulWidget {
  const ResponsiveTableCardsGen02967({super.key});

  @override
  State<ResponsiveTableCardsGen02967> createState() => _ResponsiveTableCardsGen02967State();
}

class _ResponsiveTableCardsGen02967State extends State<ResponsiveTableCardsGen02967> {
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    // Simulate API sync delay
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isRefreshing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data synchronized successfully.'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isDesktop = constraints.maxWidth >= 840;

        return RefreshIndicator(
          onRefresh: _handleRefresh,
          edgeOffset: kToolbarHeight,
          child: isMobile
              ? _buildMobileCardStack(context)
              : isDesktop
                  ? _buildDesktopDataGrid(context)
                  : _buildTabletLayout(context),
        );
      },
    );
  }

  Widget _buildMobileCardStack(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      itemCount: _mockTableData.length,
      itemBuilder: (context, index) {
        final row = _mockTableData[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _M3StatusCard(
            row: row,
            elevation: 3.0,
            theme: theme,
          ),
        );
      },
    );
  }

  Widget _buildDesktopDataGrid(BuildContext context) {
    final theme = Theme.of(context);
    if (_mockTableData.isEmpty) return const SizedBox.shrink();

    final headers = _mockTableData.first.columns.keys.toList();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: DataTable(
          headingRowHeight: 56.0,
          dataRowMinHeight: 48.0,
          dataRowMaxHeight: 48.0,
          columns: [
            const DataColumn(label: Text('ID')),
            ...headers.map((h) => DataColumn(label: Text(h))),
            const DataColumn(label: Text('Status')),
          ],
          rows: _mockTableData.map((row) {
            return DataRow(
              cells: [
                DataCell(Text(row.id)),
                ...headers.map((h) => DataCell(Text(row.columns[h] ?? ''))),
                DataCell(_buildStatusChip(row.status, theme)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: _mockTableData.length,
      itemBuilder: (context, index) {
        return _M3StatusCard(
          row: _mockTableData[index],
          elevation: 3.0,
          theme: Theme.of(context),
        );
      },
    );
  }

  Widget _buildStatusChip(String status, ThemeData theme) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        break;
      case 'in progress':
        color = Colors.orange;
        break;
      case 'failed':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
      backgroundColor: color.withOpacity(0.12),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _M3StatusCard extends StatelessWidget {
  final ExtractedTableRow row;
  final double elevation;
  final ThemeData theme;

  const _M3StatusCard({
    required this.row,
    required this.elevation,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Deep-link drill-down simulation
          showModalBottomSheet(
            context: context,
            builder: (ctx) => _buildConfigBottomSheet(ctx),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    row.id,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  _buildStatusChip(row.status, theme),
                ],
              ),
              const SizedBox(height: 12.0),
              ...row.columns.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          '${entry.key}:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, ThemeData theme) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        break;
      case 'in progress':
        color = Colors.orange;
        break;
      case 'failed':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
      backgroundColor: color.withOpacity(0.12),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildConfigBottomSheet(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            Text('Deep-link drill-down for ${row.id}'),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              height: 48.0,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}