// GEN-02758 — WCAG Violation Report Review & Categorization Card.
// Displays violation report data categorized by WCAG success criterion, severity, and affected component using M3 Elevated Cards and Status Chips. Single-column mobile layout with 48x48dp touch targets and Material You dynamic color support.

import 'package:flutter/material.dart';

enum WcagSeverity { critical, serious, moderate, minor }

class WcagViolation {
  final String id;
  final String successCriterion;
  final WcagSeverity severity;
  final String affectedComponent;
  final String description;
  final bool isFixed;

  const WcagViolation({
    required this.id,
    required this.successCriterion,
    required this.severity,
    required this.affectedComponent,
    required this.description,
    required this.isFixed,
  });
}

const List<WcagViolation> _mockViolations = [
  WcagViolation(
    id: 'VIO-001',
    successCriterion: '1.1.1 Non-text Content',
    severity: WcagSeverity.critical,
    affectedComponent: 'ProfileAvatar',
    description: 'Image missing alt text for screen readers.',
    isFixed: false,
  ),
  WcagViolation(
    id: 'VIO-002',
    successCriterion: '1.4.3 Contrast (Minimum)',
    severity: WcagSeverity.serious,
    affectedComponent: 'SubmitButton',
    description: 'Text contrast ratio is 3.2:1, below 4.5:1 minimum.',
    isFixed: true,
  ),
  WcagViolation(
    id: 'VIO-003',
    successCriterion: '2.1.1 Keyboard',
    severity: WcagSeverity.moderate,
    affectedComponent: 'BottomNavigationBar',
    description: 'Navigation items not reachable via keyboard focus.',
    isFixed: false,
  ),
  WcagViolation(
    id: 'VIO-004',
    successCriterion: '4.1.2 Name, Role, Value',
    severity: WcagSeverity.minor,
    affectedComponent: 'CustomToggle',
    description: 'Toggle switch missing accessible role semantics.',
    isFixed: true,
  ),
];

class WcagViolationReportCardGen02758 extends StatefulWidget {
  const WcagViolationReportCardGen02758({super.key});

  @override
  State<WcagViolationReportCardGen02758> createState() => _WcagViolationReportCardGen02758State();
}

class _WcagViolationReportCardGen02758State extends State<WcagViolationReportCardGen02758> {
  late List<WcagViolation> _violations;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _violations = List.from(_mockViolations);
    _startPolling();
  }

  void _startPolling() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _simulateRefresh();
        _startPolling();
      }
    });
  }

  Future<void> _simulateRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 80));
    if (mounted) {
      setState(() {
        _violations = List.from(_mockViolations);
        _isRefreshing = false;
      });
    }
  }

  int get _criticalCount => _violations.where((v) => v.severity == WcagSeverity.critical && !v.isFixed).length;
  bool get _allCriticalFixed => _criticalCount == 0;
  String get _complianceStatus => _allCriticalFixed ? 'Pass' : 'Fail';

  Color _severityColor(WcagSeverity severity, ColorScheme cs) {
    switch (severity) {
      case WcagSeverity.critical:
        return cs.error;
      case WcagSeverity.serious:
        return cs.tertiary;
      case WcagSeverity.moderate:
        return cs.primary;
      case WcagSeverity.minor:
        return cs.outline;
    }
  }

  String _severityLabel(WcagSeverity severity) {
    switch (severity) {
      case WcagSeverity.critical:
        return 'Critical';
      case WcagSeverity.serious:
        return 'Serious';
      case WcagSeverity.moderate:
        return 'Moderate';
      case WcagSeverity.minor:
        return 'Minor';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return RefreshIndicator(
      onRefresh: _simulateRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKpiHeader(cs, textTheme),
            const SizedBox(height: 16),
            Text(
              'Categorized Violations',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ..._violations.map((v) => _buildViolationCard(v, cs, textTheme)),
            if (_isRefreshing)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiHeader(ColorScheme cs, TextTheme textTheme) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withOpacity(0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('WCAG 2.2 AA Compliance Rate', style: textTheme.titleSmall),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _complianceStatus,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _allCriticalFixed ? cs.primary : cs.error,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Floor: All critical violations fixed',
                      style: textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
                Chip(
                  avatar: Icon(
                    _allCriticalFixed ? Icons.check_circle : Icons.error,
                    size: 18,
                    color: _allCriticalFixed ? cs.primary : cs.error,
                  ),
                  label: Text(
                    _allCriticalFixed ? 'Compliant' : '$_criticalCount Critical Open',
                    style: TextStyle(
                      color: _allCriticalFixed ? cs.primary : cs.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: (_allCriticalFixed ? cs.primary : cs.error).withOpacity(0.12),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViolationCard(WcagViolation violation, ColorScheme cs, TextTheme textTheme) {
    final sevColor = _severityColor(violation.severity, cs);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Drill-down for ${violation.id}'),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(label: 'OK', onPressed: () {}),
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
                        violation.successCriterion,
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Chip(
                      label: Text(
                        _severityLabel(violation.severity),
                        style: TextStyle(color: sevColor, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: sevColor.withOpacity(0.12),
                      side: BorderSide(color: sevColor.withOpacity(0.3)),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.widgets_outlined, size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(
                      violation.affectedComponent,
                      style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const Spacer(),
                    Icon(
                      violation.isFixed ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                      size: 20,
                      color: violation.isFixed ? cs.primary : cs.error,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  violation.description,
                  style: textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}