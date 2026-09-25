// GEN-03066 — Clause Card Tap to View Nonconformity Records and Evidence Trail.
// Implements a tappable M3 ElevatedCard displaying clause info. Tapping opens a modal bottom sheet with nonconformity records and evidence trail using mock data. Single-column mobile layout, 48x48dp touch targets, Material You dynamic color.

import 'package:flutter/material.dart';

class ClauseCardWidgetGen03066 extends StatelessWidget {
  const ClauseCardWidgetGen03066({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'View nonconformity records for ISO 9001 Clause 4.1',
      child: SizedBox(
        width: double.infinity,
        height: 48.0,
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _showNonconformityDetails(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Icon(
                    Icons.gavel_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ISO 9001 - Clause 4.1',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          'Understanding the organization and its context',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: const Text('2 NCs'),
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 8.0),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showNonconformityDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (BuildContext sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return _NonconformityBottomSheet(scrollController: scrollController);
          },
        );
      },
    );
  }
}

class _NonconformityBottomSheet extends StatelessWidget {
  final ScrollController scrollController;

  const _NonconformityBottomSheet({required this.scrollController});

  static const List<Map<String, dynamic>> _mockNonconformities = [
    {
      'id': 'NC-2026-001',
      'title': 'Missing Context Analysis Documentation',
      'status': 'Open',
      'date': '2026-09-10',
      'severity': 'Major',
      'evidence': [
        {'type': 'Document', 'name': 'Audit_Report_Q3.pdf', 'timestamp': '2026-09-10T14:30:00Z'},
        {'type': 'Photo', 'name': 'IMG_Evidence_01.jpg', 'timestamp': '2026-09-10T15:00:00Z'},
      ]
    },
    {
      'id': 'NC-2026-002',
      'title': 'Failure to monitor external issues',
      'status': 'In Progress',
      'date': '2026-09-15',
      'severity': 'Minor',
      'evidence': [
        {'type': 'Note', 'name': 'Auditor observation note', 'timestamp': '2026-09-15T09:15:00Z'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
          child: Container(
            width: 32.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                'Nonconformity Records',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                tooltip: 'Close',
                constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
              ),
            ],
          ),
        ),
        const Divider(height: 1.0),
        Expanded(
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.all(16.0),
            itemCount: _mockNonconformities.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16.0),
            itemBuilder: (context, index) {
              final nc = _mockNonconformities[index];
              return _buildNonconformityCard(context, nc);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNonconformityCard(BuildContext context, Map<String, dynamic> nc) {
    final theme = Theme.of(context);
    final bool isMajor = nc['severity'] == 'Major';
    final Color statusColor = isMajor ? theme.colorScheme.error : theme.colorScheme.tertiary;

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    nc['severity'],
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  nc['id'],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(nc['status']),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: nc['status'] == 'Open'
                      ? theme.colorScheme.errorContainer
                      : theme.colorScheme.secondaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              nc['title'],
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Identified on: ${nc['date']}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(height: 1.0),
            const SizedBox(height: 12.0),
            Text(
              'Evidence Trail',
              style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ...((nc['evidence'] as List).map((ev) => _buildEvidenceTile(context, ev)).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceTile(BuildContext context, Map<String, dynamic> ev) {
    final theme = Theme.of(context);
    IconData iconData;
    switch (ev['type']) {
      case 'Photo':
        iconData = Icons.photo_library_outlined;
        break;
      case 'Document':
        iconData = Icons.description_outlined;
        break;
      default:
        iconData = Icons.note_outlined;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(iconData, size: 20.0, color: theme.colorScheme.primary),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ev['name'],
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${ev['type']} • ${ev['timestamp'].toString().substring(0, 10)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${ev['name']}...'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              );
            },
            icon: const Icon(Icons.download_outlined),
            constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
            tooltip: 'Download evidence',
          ),
        ],
      ),
    );
  }
}