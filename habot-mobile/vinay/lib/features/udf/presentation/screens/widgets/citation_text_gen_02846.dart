// GEN-02846 — Citation text widget configured to use labelSmall (11 sp) on mobile screens.
// Implements M3 Elevated Card with inline status chip, responsive single-column layout (<600dp), and 48x48dp touch targets.

import 'package:flutter/material.dart';

/// Mock data representing the citation step completion state.
class _CitationMockData {
  final String id;
  final String title;
  final String status; // Good, Average, Poor
  final double errorRate;
  final DateTime timestamp;

  const _CitationMockData({
    required this.id,
    required this.title,
    required this.status,
    required this.errorRate,
    required this.timestamp,
  });
}

const List<_CitationMockData> _mockCitations = [
  _CitationMockData(
    id: 'trace_001',
    title: 'NIST AI RMF 1.0 Grounding Check',
    status: 'Good',
    errorRate: 1.2,
    timestamp: DateTime(2026, 9, 25, 10, 30),
  ),
  _CitationMockData(
    id: 'trace_002',
    title: 'Hallucination Rate Validation',
    status: 'Average',
    errorRate: 4.8,
    timestamp: DateTime(2026, 9, 25, 10, 31),
  ),
  _CitationMockData(
    id: 'trace_003',
    title: 'Backend Configuration Sync',
    status: 'Poor',
    errorRate: 8.5,
    timestamp: DateTime(2026, 9, 25, 10, 32),
  ),
];

class CitationTextGen02846 extends StatelessWidget {
  const CitationTextGen02846({super.key});

  Color _getStatusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case 'Good':
        return colorScheme.primary;
      case 'Average':
        return colorScheme.tertiary;
      case 'Poor':
        return colorScheme.error;
      default:
        return colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Enforce labelSmall (11 sp) for citation text as per requirement
    final citationTextStyle = textTheme.labelSmall?.copyWith(
      fontSize: 11.0,
      color: colorScheme.onSurfaceVariant,
    ) ?? const TextStyle(fontSize: 11.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        // M3 responsive layout: single-column on mobile (<600dp)
        final isMobile = constraints.maxWidth < 600;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Engineering Console - Citation Health',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 16.0),
              if (isMobile)
                ..._buildMobileLayout(context, citationTextStyle)
              else
                _buildDesktopLayout(context, citationTextStyle),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildMobileLayout(
    BuildContext context,
    TextStyle citationTextStyle,
  ) {
    return _mockCitations.map((citation) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: _CitationCard(
          citation: citation,
          citationTextStyle: citationTextStyle,
          statusColor: _getStatusColor(context, citation.status),
        ),
      );
    }).toList();
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    TextStyle citationTextStyle,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        childAspectRatio: 2.5,
      ),
      itemCount: _mockCitations.length,
      itemBuilder: (context, index) {
        final citation = _mockCitations[index];
        return _CitationCard(
          citation: citation,
          citationTextStyle: citationTextStyle,
          statusColor: _getStatusColor(context, citation.status),
        );
      },
    );
  }
}

class _CitationCard extends StatelessWidget {
  final _CitationMockData citation;
  final TextStyle citationTextStyle;
  final Color statusColor;

  const _CitationCard({
    required this.citation,
    required this.citationTextStyle,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // 48x48dp minimum touch target enforcement
      height: 48.0,
      child: Card(
        elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Drill-down triggered for ${citation.id}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        citation.title,
                        style: citationTextStyle, // labelSmall (11 sp)
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Error Rate: ${citation.errorRate.toStringAsFixed(1)}%',
                        style: citationTextStyle.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                // M3 Status Chip
                Chip(
                  label: Text(
                    citation.status,
                    style: TextStyle(
                      fontSize: 11.0,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: statusColor.withOpacity(0.12),
                  side: BorderSide.none,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
