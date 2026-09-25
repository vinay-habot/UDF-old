// GEN-03110 — Personal Gain Share Dashboard Card.
// Displays a Material 3 ElevatedCard with real-time monthly bonus projections, responsive single/multi-column layout, 30s polling, and pull-to-refresh support.

import 'dart:async';
import 'package:flutter/material.dart';

enum UsabilityStatus { good, average, poor }

class GainShareProjection {
  final String month;
  final double projectedBonus;
  final double targetBonus;
  final double completionPercentage;
  final UsabilityStatus status;
  final DateTime lastUpdated;

  const GainShareProjection({
    required this.month,
    required this.projectedBonus,
    required this.targetBonus,
    required this.completionPercentage,
    required this.status,
    required this.lastUpdated,
  });
}

class MockGainShareRepository {
  static List<GainShareProjection> fetchProjections() {
    final now = DateTime.now();
    return [
      GainShareProjection(
        month: 'September 2026',
        projectedBonus: 1250.00,
        targetBonus: 1500.00,
        completionPercentage: 83.3,
        status: UsabilityStatus.good,
        lastUpdated: now,
      ),
      GainShareProjection(
        month: 'October 2026',
        projectedBonus: 750.00,
        targetBonus: 1500.00,
        completionPercentage: 50.0,
        status: UsabilityStatus.average,
        lastUpdated: now,
      ),
      GainShareProjection(
        month: 'November 2026',
        projectedBonus: 300.00,
        targetBonus: 1500.00,
        completionPercentage: 20.0,
        status: UsabilityStatus.poor,
        lastUpdated: now,
      ),
    ];
  }
}

class PersonalGainShareCardGen03110 extends StatefulWidget {
  const PersonalGainShareCardGen03110({super.key});

  @override
  State<PersonalGainShareCardGen03110> createState() => _PersonalGainShareCardGen03110State();
}

class _PersonalGainShareCardGen03110State extends State<PersonalGainShareCardGen03110> {
  late List<GainShareProjection> _projections;
  Timer? _pollingTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _projections = MockGainShareRepository.fetchProjections();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() {
      _projections = MockGainShareRepository.fetchProjections();
      _isRefreshing = false;
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Color _getStatusColor(UsabilityStatus status, ThemeData theme) {
    switch (status) {
      case UsabilityStatus.good:
        return theme.colorScheme.primary;
      case UsabilityStatus.average:
        return theme.colorScheme.tertiary;
      case UsabilityStatus.poor:
        return theme.colorScheme.error;
    }
  }

  String _getStatusLabel(UsabilityStatus status) {
    switch (status) {
      case UsabilityStatus.good:
        return 'Good';
      case UsabilityStatus.average:
        return 'Average';
      case UsabilityStatus.poor:
        return 'Poor';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 840;

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Gain Share',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Real-time monthly bonus projections',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              if (_isRefreshing)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: LinearProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                ),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _projections
                          .map((p) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: _buildProjectionCard(p, theme),
                                ),
                              ))
                          .toList(),
                    )
                  : Column(
                      children: _projections
                          .map((p) => Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: _buildProjectionCard(p, theme),
                              ))
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectionCard(GainShareProjection projection, ThemeData theme) {
    final statusColor = _getStatusColor(projection.status, theme);

    // M3 Elevated Card Level 2 (3dp elevation)
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Drill-down for ${projection.month}'),
              behavior: SnackBarBehavior.floating,
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
                      projection.month,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // M3 Status Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      _getStatusLabel(projection.status),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Projected',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${projection.projectedBonus.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Target',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${projection.targetBonus.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: LinearProgressIndicator(
                  value: projection.completionPercentage / 100.0,
                  minHeight: 8.0,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${projection.completionPercentage.toStringAsFixed(1)}%',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Updated: ${projection.lastUpdated.hour}:${projection.lastUpdated.minute.toString().padLeft(2, '0')}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
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
