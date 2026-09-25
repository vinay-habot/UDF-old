// GEN-02626 — Accessible UI Component Byte packaging for UDF engineering console.
// Provides M3 Elevated Cards, Status Chips, and responsive layouts with WCAG 2.2 AA compliance and Material You dynamic color support.

import 'package:flutter/material.dart';

/// Mock data representing the accessible component byte execution state.
class ComponentByteMockData {
  static const String stepId = 'GEN-02626';
  static const String stepName = 'Package Accessible UI Component Byts';
  static const double uiComplianceRate = 0.98;
  static const String status = 'Pass';
  static const String lastUpdated = '2026-09-25T14:30:00Z';
  static const String sessionId = 'sess_udf_001';
}

/// A reusable M3 Elevated Card (Level 2 - 3dp) displaying step completion state.
/// Implements 48x48dp touch targets and WCAG 2.2 AA contrast requirements.
class AccessibleStatusCard extends StatelessWidget {
  final String title;
  final String status;
  final double complianceRate;
  final VoidCallback? onDeepLinkTap;

  const AccessibleStatusCard({
    super.key,
    required this.title,
    required this.status,
    required this.complianceRate,
    this.onDeepLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPassing = complianceRate >= 0.95;

    return Semantics(
      label: 'Step status card for $title',
      value: 'Status: $status, Compliance: ${(complianceRate * 100).toStringAsFixed(1)}%',
      button: onDeepLinkTap != null,
      child: Card(
        elevation: 3.0, // M3 Elevated Card Level 2
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: onDeepLinkTap,
          // Enforce 48x48dp minimum touch target
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    _M3StatusChip(
                      label: status,
                      isSuccess: isPassing,
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                LinearProgressIndicator(
                  value: complianceRate.clamp(0.0, 1.0),
                  minHeight: 6.0,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPassing ? colorScheme.primary : colorScheme.error,
                  ),
                  semanticsLabel: 'UI Compliance Rate',
                  semanticsValue: '${(complianceRate * 100).toStringAsFixed(1)}%',
                ),
                const SizedBox(height: 8.0),
                Text(
                  'UI Compliance Rate: ${(complianceRate * 100).toStringAsFixed(1)}% (Floor: 95%)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// M3 Status Chip for health indicators.
class _M3StatusChip extends StatelessWidget {
  final String label;
  final bool isSuccess;

  const _M3StatusChip({
    required this.label,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Chip(
      avatar: Icon(
        isSuccess ? Icons.check_circle_outline : Icons.error_outline,
        size: 18.0,
        color: isSuccess ? colorScheme.onSecondaryContainer : colorScheme.onErrorContainer,
      ),
      label: Text(label),
      labelStyle: TextStyle(
        color: isSuccess ? colorScheme.onSecondaryContainer : colorScheme.onErrorContainer,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: isSuccess ? colorScheme.secondaryContainer : colorScheme.errorContainer,
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Responsive layout wrapper enforcing M3 breakpoints:
/// Single-column on mobile (<600dp), multi-column on desktop (>=840dp).
class AccessibleComponentByteLayout extends StatelessWidget {
  final List<Widget> cards;

  const AccessibleComponentByteLayout({
    super.key,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 840.0) {
          // Desktop: Multi-column grid
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400.0,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              mainAxisExtent: 160.0,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) => cards[index],
          );
        } else {
          // Mobile/Tablet (<840dp): Single-column list
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: cards.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16.0),
            itemBuilder: (context, index) => cards[index],
          );
        }
      },
    );
  }
}

/// Engineering Console Screen demonstrating the packaged accessible components
/// with mock data, background polling simulation, and pull-to-refresh.
class EngineeringConsoleScreenGen02626 extends StatefulWidget {
  const EngineeringConsoleScreenGen02626({super.key});

  @override
  State<EngineeringConsoleScreenGen02626> createState() => _EngineeringConsoleScreenGen02626State();
}

class _EngineeringConsoleScreenGen02626State extends State<EngineeringConsoleScreenGen02626> {
  late double _currentCompliance;
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentCompliance = ComponentByteMockData.uiComplianceRate;
    _currentStatus = ComponentByteMockData.status;
    _startPolling();
  }

  void _startPolling() {
    // Simulates background polling every 30 seconds as per requirement.
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          // Mock fluctuation within acceptable bounds
          _currentCompliance = 0.95 + (DateTime.now().millisecond % 5) / 100.0;
          _currentStatus = _currentCompliance >= 0.95 ? 'Pass' : 'Fail';
        });
        _startPolling();
      }
    });
  }

  Future<void> _handleRefresh() async {
    // Simulates manual sync via pull-to-refresh
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _currentCompliance = ComponentByteMockData.uiComplianceRate;
        _currentStatus = ComponentByteMockData.status;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Manual sync completed successfully.'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            action: SnackBarAction(
              label: 'DISMISS',
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  void _showConfigBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24.0,
            right: 24.0,
            top: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 32.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Configuration Inputs',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Trace ID Filter',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 48.0, // 48x48dp touch target
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Configuration'),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UDF Engineering Console'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Open configuration inputs',
            onPressed: _showConfigBottomSheet,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        edgeOffset: kToolbarHeight,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Text(
                  'Step Health Dashboard',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: AccessibleComponentByteLayout(
                cards: [
                  AccessibleStatusCard(
                    title: ComponentByteMockData.stepName,
                    status: _currentStatus,
                    complianceRate: _currentCompliance,
                    onDeepLinkTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Drilling down into trace logs...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  // Additional mock cards to demonstrate layout behavior
                  AccessibleStatusCard(
                    title: 'Dependency Validation: GEN-02625',
                    status: 'Pass',
                    complianceRate: 1.0,
                    onDeepLinkTap: () {},
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Last synced: ${ComponentByteMockData.lastUpdated}\nSession: ${ComponentByteMockData.sessionId}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}