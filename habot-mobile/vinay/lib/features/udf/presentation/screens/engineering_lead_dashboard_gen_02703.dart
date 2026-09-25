// GEN-02703 — Engineering Lead Dashboard with M3 Swipeable List Items for Approvals.
// Mobile-optimized dashboard using Material 3 Elevated Cards, Status Chips, and Dismissible list items. Includes mock data, background polling (30s), pull-to-refresh, and RAIL-compliant interaction latency tracking.

import 'dart:async';
import 'package:flutter/material.dart';

enum ApprovalStatus { pending, approved, rejected }

class ApprovalItem {
  final String id;
  final String title;
  final String description;
  final ApprovalStatus status;
  final DateTime timestamp;

  const ApprovalItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.timestamp,
  });
}

class MockApprovalRepository {
  static List<ApprovalItem> getApprovals() => [
        const ApprovalItem(
          id: 'APR-001',
          title: 'Deploy Auth Service v2.4',
          description: 'Production deployment approval requested by CI/CD pipeline.',
          status: ApprovalStatus.pending,
          timestamp: DateTime(2026, 9, 25, 10, 30),
        ),
        const ApprovalItem(
          id: 'APR-002',
          title: 'Database Migration - UDF Schema',
          description: 'Schema update requires engineering lead sign-off.',
          status: ApprovalStatus.pending,
          timestamp: DateTime(2026, 9, 25, 11, 15),
        ),
        const ApprovalItem(
          id: 'APR-003',
          title: 'Feature Flag: Dark Mode Rollout',
          description: 'Enable dark mode for 50% of mobile users.',
          status: ApprovalStatus.approved,
          timestamp: DateTime(2026, 9, 24, 16, 45),
        ),
        const ApprovalItem(
          id: 'APR-004',
          title: 'Security Patch - CVE-2026-8832',
          description: 'Critical dependency update requiring immediate merge.',
          status: ApprovalStatus.rejected,
          timestamp: DateTime(2026, 9, 24, 09, 00),
        ),
      ];
}

class EngineeringLeadDashboardGen02703 extends StatefulWidget {
  const EngineeringLeadDashboardGen02703({super.key});

  @override
  State<EngineeringLeadDashboardGen02703> createState() => _EngineeringLeadDashboardGen02703State();
}

class _EngineeringLeadDashboardGen02703State extends State<EngineeringLeadDashboardGen02703> {
  late List<ApprovalItem> _approvals;
  bool _isRefreshing = false;
  Timer? _pollingTimer;
  int _pendingCount = 0;
  int _completedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Background polling refreshes data every 30 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) => _loadData());
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isRefreshing = true);
    
    // Simulate API latency < 100ms per RAIL model
    await Future.delayed(const Duration(milliseconds: 80));
    
    final data = MockApprovalRepository.getApprovals();
    if (mounted) {
      setState(() {
        _approvals = data;
        _pendingCount = data.where((e) => e.status == ApprovalStatus.pending).length;
        _completedCount = data.where((e) => e.status != ApprovalStatus.pending).length;
        _isRefreshing = false;
      });
    }
  }

  void _handleSwipeAction(ApprovalItem item, ApprovalStatus newStatus) {
    final stopwatch = Stopwatch()..start();
    
    setState(() {
      _approvals = _approvals.map((e) {
        if (e.id == item.id) {
          return ApprovalItem(
            id: e.id,
            title: e.title,
            description: e.description,
            status: newStatus,
            timestamp: e.timestamp,
          );
        }
        return e;
      }).toList();
      _pendingCount = _approvals.where((e) => e.status == ApprovalStatus.pending).length;
      _completedCount = _approvals.where((e) => e.status != ApprovalStatus.pending).length;
    });

    stopwatch.stop();
    final latencyMs = stopwatch.elapsedMilliseconds;
    final qualitative = latencyMs < 100 ? 'Good' : (latencyMs < 300 ? 'Average' : 'Poor');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.title} ${newStatus.name}. Latency: $latencyMs ms ($qualitative)'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Console'),
        centerTitle: false,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // M3 responsive layout: single-column on mobile (<600dp), multi-column on desktop (>=840dp)
            final isDesktop = constraints.maxWidth >= 840;
            
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: isDesktop ? _buildMultiColumnLayout(colorScheme, textTheme) : _buildSingleColumnLayout(colorScheme, textTheme),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSingleColumnLayout(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildKpiCards(colorScheme, textTheme, isRow: false),
        const SizedBox(height: 24),
        _buildApprovalsList(colorScheme, textTheme),
      ],
    );
  }

  Widget _buildMultiColumnLayout(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: _buildKpiCards(colorScheme, textTheme, isRow: true)),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: _buildApprovalsList(colorScheme, textTheme)),
      ],
    );
  }

  Widget _buildKpiCards(ColorScheme colorScheme, TextTheme textTheme, {required bool isRow}) {
    final cards = [
      _buildElevatedKpiCard(
        title: 'Pending Approvals',
        value: _pendingCount.toString(),
        status: _pendingCount > 0 ? 'Attention Needed' : 'Clear',
        chipColor: _pendingCount > 0 ? colorScheme.errorContainer : colorScheme.primaryContainer,
        chipText: _pendingCount > 0 ? colorScheme.onErrorContainer : colorScheme.onPrimaryContainer,
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      _buildElevatedKpiCard(
        title: 'Completed Steps',
        value: _completedCount.toString(),
        status: 'Healthy',
        chipColor: colorScheme.secondaryContainer,
        chipText: colorScheme.onSecondaryContainer,
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    ];

    if (isRow) {
      return Column(children: [cards[0], const SizedBox(height: 16), cards[1]]);
    }
    return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 16), child: c)).toList());
  }

  Widget _buildElevatedKpiCard({
    required String title,
    required String value,
    required String status,
    required Color chipColor,
    required Color chipText,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    // M3 Elevated Cards Level 2 (3dp)
    return Card(
      elevation: 3.0,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text(value, style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 12),
            // M3 Status Chips for health indicators
            Chip(
              label: Text(status, style: TextStyle(color: chipText, fontWeight: FontWeight.w500)),
              backgroundColor: chipColor,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              side: BorderSide.none,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalsList(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text('Approval Queue', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
        ),
        if (_isRefreshing)
          const LinearProgressIndicator(minHeight: 2)
        else
          const SizedBox.shrink(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _approvals.length,
          itemBuilder: (context, index) {
            final item = _approvals[index];
            return _buildSwipeableListItem(item, colorScheme, textTheme);
          },
        ),
      ],
    );
  }

  Widget _buildSwipeableListItem(ApprovalItem item, ColorScheme colorScheme, TextTheme textTheme) {
    // Read-only M3 KPI cards with deep-link drill-down conceptually represented here as interactive swipe items
    // 48x48dp touch targets enforced via minimum ListTile height and icon sizes
    
    final isPending = item.status == ApprovalStatus.pending;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Dismissible(
        key: ValueKey(item.id),
        direction: isPending ? DismissDirection.horizontal : DismissDirection.none,
        confirmDismiss: (direction) async {
          // M3 Bottom Sheet for configuration inputs / confirmation
          final confirmed = await showModalBottomSheet<bool>(
            context: context,
            builder: (ctx) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        direction == DismissDirection.endToStart ? 'Reject Approval?' : 'Approve Item?',
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(item.title, style: textTheme.bodyLarge),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          FilledButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          return confirmed ?? false;
        },
        onDismissed: (direction) {
          final newStatus = direction == DismissDirection.endToStart ? ApprovalStatus.rejected : ApprovalStatus.approved;
          _handleSwipeAction(item, newStatus);
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20.0),
          color: colorScheme.primaryContainer,
          child: Icon(Icons.check_circle_outline, color: colorScheme.onPrimaryContainer, size: 32),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          color: colorScheme.errorContainer,
          child: Icon(Icons.cancel_outlined, color: colorScheme.onErrorContainer, size: 32),
        ),
        child: Card(
          elevation: item.status == ApprovalStatus.pending ? 1.0 : 0.0,
          color: item.status == ApprovalStatus.pending ? null : colorScheme.surfaceVariant.withOpacity(0.5),
          margin: EdgeInsets.zero,
          child: ListTile(
            minVerticalPadding: 16.0,
            leading: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: Icon(
                  item.status == ApprovalStatus.pending
                      ? Icons.pending_actions
                      : item.status == ApprovalStatus.approved
                          ? Icons.task_alt
                          : Icons.block,
                  color: item.status == ApprovalStatus.pending
                      ? colorScheme.primary
                      : item.status == ApprovalStatus.approved
                          ? colorScheme.tertiary
                          : colorScheme.error,
                  size: 28,
                ),
              ),
            ),
            title: Text(item.title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(item.description, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            ),
            trailing: isPending
                ? Icon(Icons.chevron_right, size: 24, color: colorScheme.onSurfaceVariant)
                : Chip(
                    label: Text(item.status.name.toUpperCase(), style: textTheme.labelSmall),
                    visualDensity: VisualDensity.compact,
                  ),
            onTap: isPending
                ? () {
                    // Deep-link drill-down placeholder
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Drill-down for ${item.id} triggered.')),
                    );
                  }
                : null,
          ),
        ),
      ),
    );
  }
}
