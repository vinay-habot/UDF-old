// GEN-02824 — Material Error Container styling for mobile refusal warning banners.
// Applies M3 Elevated Card Level 2 (3dp) styling, status chips, 48x48dp touch targets, and responsive single/multi-column layout to all refusal warning banners.

import 'package:flutter/material.dart';

/// Mock data representing refusal warning banner entries for local rendering.
class RefusalWarningMockData {
  static const List<Map<String, dynamic>> warnings = [
    {
      'id': 'WARN-001',
      'title': 'Permission Refused',
      'message': 'Camera access was denied. Please enable it in settings.',
      'severity': 'error',
      'timestamp': '2026-09-25T10:00:00Z',
    },
    {
      'id': 'WARN-002',
      'title': 'Action Blocked',
      'message': 'Transaction could not be completed due to policy restrictions.',
      'severity': 'warning',
      'timestamp': '2026-09-25T10:05:00Z',
    },
    {
      'id': 'WARN-003',
      'title': 'Validation Failed',
      'message': 'Input data does not meet the required format standards.',
      'severity': 'error',
      'timestamp': '2026-09-25T10:12:00Z',
    },
  ];
}

/// A reusable M3-styled refusal warning banner widget.
/// Implements Material Error Container styling with Elevated Card Level 2 (3dp),
/// Status Chips for health indicators, and 48x48dp touch targets.
class RefusalWarningBanner extends StatelessWidget {
  final String title;
  final String message;
  final String severity;
  final VoidCallback? onDismiss;

  const RefusalWarningBanner({
    super.key,
    required this.title,
    required this.message,
    required this.severity,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on severity using Material You dynamic color tokens
    final Color containerColor = severity == 'error'
        ? colorScheme.errorContainer
        : colorScheme.tertiaryContainer;
    final Color onContainerColor = severity == 'error'
        ? colorScheme.onErrorContainer
        : colorScheme.onTertiaryContainer;

    return Card(
      // M3 Elevated Cards Level 2 (3dp elevation)
      elevation: 3.0,
      color: containerColor,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              severity == 'error' ? Icons.error_outline : Icons.warning_amber_rounded,
              color: onContainerColor,
              size: 24.0,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: onContainerColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // M3 Status Chip for health indicator
                      _buildStatusChip(theme, severity, onContainerColor),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onContainerColor.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            if (onDismiss != null) ...[
              const SizedBox(width: 8.0),
              // 48x48dp touch target requirement
              SizedBox(
                width: 48.0,
                height: 48.0,
                child: IconButton(
                  icon: Icon(Icons.close, color: onContainerColor),
                  onPressed: onDismiss,
                  tooltip: 'Dismiss warning',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, String severity, Color color) {
    return Chip(
      label: Text(
        severity.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color.withOpacity(0.2),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Responsive layout wrapper that displays a list of refusal warning banners.
/// Single-column on mobile (<600dp), multi-column on desktop (>=840dp).
class RefusalWarningBannerList extends StatelessWidget {
  const RefusalWarningBannerList({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth >= 840.0 ? 2 : 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: crossAxisCount == 1 ? 4.5 : 3.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: RefusalWarningMockData.warnings.length,
          itemBuilder: (context, index) {
            final warning = RefusalWarningMockData.warnings[index];
            return RefusalWarningBanner(
              title: warning['title'] as String,
              message: warning['message'] as String,
              severity: warning['severity'] as String,
              onDismiss: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Dismissed ${warning["id"]}'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
