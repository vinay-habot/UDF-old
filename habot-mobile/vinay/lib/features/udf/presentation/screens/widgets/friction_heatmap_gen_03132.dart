// GEN-03132 — Mobile Friction Heatmap Widget.
// Displays real-time UI hesitation points using M3 Elevated Cards, Status Chips, and a 30-second polling refresh mechanism.

import 'dart:async';
import 'package:flutter/material.dart';

enum FrictionStatus { good, average, poor }

class HesitationPoint {
  final String id;
  final String sessionId;
  final String elementName;
  final double frictionRate;
  final DateTime timestamp;
  final FrictionStatus status;

  const HesitationPoint({
    required this.id,
    required this.sessionId,
    required this.elementName,
    required this.frictionRate,
    required this.timestamp,
    required this.status,
  });
}

class MockFrictionRepository {
  static List<HesitationPoint> getMockData() {
    return [
      HesitationPoint(
        id: 'HP-001',
        sessionId: 'SESS-8821',
        elementName: 'Checkout Submit Button',
        frictionRate: 18.5,
        timestamp: DateTime.now().subtract(const Duration(seconds: 12)),
        status: FrictionStatus.poor,
      ),
      HesitationPoint(
        id: 'HP-002',
        sessionId: 'SESS-8822',
        elementName: 'Profile Dropdown Menu',
        frictionRate: 12.0,
        timestamp: DateTime.now().subtract(const Duration(seconds: 45)),
        status: FrictionStatus.average,
      ),
      HesitationPoint(
        id: 'HP-003',
        sessionId: 'SESS-8823',
        elementName: 'Search Input Field',
        frictionRate: 4.2,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        status: FrictionStatus.good,
      ),
      HesitationPoint(
        id: 'HP-004',
        sessionId: 'SESS-8824',
        elementName: 'Navigation Bottom Bar',
        frictionRate: 16.1,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        status: FrictionStatus.poor,
      ),
    ];
  }
}

class FrictionHeatmapScreen extends StatefulWidget {
  const FrictionHeatmapScreen({super.key});

  @override
  State<FrictionHeatmapScreen> createState() => _FrictionHeatmapScreenState();
}

class _FrictionHeatmapScreenState extends State<FrictionHeatmapScreen> {
  List<HesitationPoint> _points = [];
  Timer? _pollingTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Background polling refreshes data every 30 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isRefreshing = true);
    
    // Simulate sub-100ms API response latency with mock data
    await Future.delayed(const Duration(milliseconds: 80));
    
    if (mounted) {
      setState(() {
        _points = MockFrictionRepository.getMockData();
        _isRefreshing = false;
      });
    }
  }

  FrictionStatus _evaluateOverallHealth() {
    if (_points.isEmpty) return FrictionStatus.good;
    final avg = _points.map((e) => e.frictionRate).reduce((a, b) => a + b) / _points.length;
    if (avg >= 15.0) return FrictionStatus.poor;
    if (avg >= 5.0) return FrictionStatus.average;
    return FrictionStatus.good;
  }

  Color _getStatusColor(FrictionStatus status, ThemeData theme) {
    switch (status) {
      case FrictionStatus.good:
        return theme.colorScheme.primary;
      case FrictionStatus.average:
        return theme.colorScheme.tertiary;
      case FrictionStatus.poor:
        return theme.colorScheme.error;
    }
  }

  String _getStatusLabel(FrictionStatus status) {
    switch (status) {
      case FrictionStatus.good:
        return 'Good';
      case FrictionStatus.average:
        return 'Average';
      case FrictionStatus.poor:
        return 'Poor';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overallStatus = _evaluateOverallHealth();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 840;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friction Heatmap'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              label: Text(
                _getStatusLabel(overallStatus),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              backgroundColor: _getStatusColor(overallStatus, theme).withOpacity(0.2),
              side: BorderSide(color: _getStatusColor(overallStatus, theme)),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (isDesktop) {
              return _buildGridView(theme, crossAxisCount: 2);
            }
            return _buildListView(theme);
          },
        ),
      ),
    );
  }

  Widget _buildGridView(ThemeData theme, {required int crossAxisCount}) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 2.5,
      ),
      itemCount: _points.length,
      itemBuilder: (context, index) => _buildHeatmapCard(_points[index], theme),
    );
  }

  Widget _buildListView(ThemeData theme) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _points.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12.0),
      itemBuilder: (context, index) {
        if (index == 0) {
          if (_isRefreshing) {
            return const LinearProgressIndicator();
          }
          return const SizedBox.shrink();
        }
        final point = _points[index - 1];
        return _buildHeatmapCard(point, theme);
      },
    );
  }

  Widget _buildHeatmapCard(HesitationPoint point, ThemeData theme) {
    final statusColor = _getStatusColor(point.status, theme);

    // M3 Elevated Card Level 2 (3dp elevation)
    return Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          // Deep-link drill-down simulation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Drilling down into ${point.elementName}...'),
              behavior: SnackBarBehavior.floating,
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
                  Expanded(
                    child: Text(
                      point.elementName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // M3 Status Chip for health indicator
                  Chip(
                    avatar: Icon(
                      Icons.circle,
                      size: 12.0,
                      color: statusColor,
                    ),
                    label: Text(
                      '${point.frictionRate.toStringAsFixed(1)}%',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: statusColor.withOpacity(0.1),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Icon(Icons.timer_outlined, size: 16.0, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4.0),
                  Text(
                    '${point.timestamp.hour}:${point.timestamp.minute.toString().padLeft(2, '0')}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Session: ${point.sessionId}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              // Visual heatmap bar representation
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: LinearProgressIndicator(
                  value: (point.frictionRate / 20.0).clamp(0.0, 1.0),
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  minHeight: 6.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
