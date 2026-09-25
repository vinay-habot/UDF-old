// GEN-02923 — Real-time traffic split adjustment via mobile touch slider.
// Implements an M3 Bottom Sheet with a touch slider for traffic split configuration, mock data, polling, and KPI cards.

import 'dart:async';
import 'package:flutter/material.dart';

/// Mock data representing backend traffic split state.
class TrafficSplitMockData {
  static double currentSplit = 50.0;
  static const String metricName = 'Content Output Quality Score (%)';
  static const double floorBoundary = 80.0;
  static const double optimalTarget = 95.0;
  static const double ceilingBoundary = 100.0;
  static double currentScore = 88.5;

  static String get qualitativeOutput {
    if (currentScore >= optimalTarget) return 'Good';
    if (currentScore >= floorBoundary) return 'Average';
    return 'Poor';
  }

  static Color qualitativeColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (qualitativeOutput) {
      case 'Good':
        return colorScheme.primary;
      case 'Average':
        return colorScheme.tertiary;
      case 'Poor':
        return colorScheme.error;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }
}

/// Main widget displaying the traffic split adjustment interface.
class TrafficSplitAdjustmentScreen extends StatefulWidget {
  const TrafficSplitAdjustmentScreen({super.key});

  @override
  State<TrafficSplitAdjustmentScreen> createState() => _TrafficSplitAdjustmentScreenState();
}

class _TrafficSplitAdjustmentScreenState extends State<TrafficSplitAdjustmentScreen> {
  Timer? _pollingTimer;
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _sliderValue = TrafficSplitMockData.currentSplit;
    // Background polling refreshes data every 30 seconds.
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _simulateDataRefresh();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _simulateDataRefresh() {
    setState(() {
      // Simulate minor fluctuations in quality score
      TrafficSplitMockData.currentScore = 
          (TrafficSplitMockData.currentScore + (DateTime.now().millisecond % 3 - 1))
              .clamp(TrafficSplitMockData.floorBoundary - 10, TrafficSplitMockData.ceilingBoundary);
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  void _onSliderChangeEnd(double value) {
    TrafficSplitMockData.currentSplit = value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Traffic split adjusted to ${value.toStringAsFixed(1)}%'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openConfigBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configure Traffic Split',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              StatefulBuilder(
                builder: (context, setModalState) {
                  return Column(
                    children: [
                      Slider(
                        value: _sliderValue,
                        min: 0.0,
                        max: 100.0,
                        divisions: 100,
                        label: '${_sliderValue.round()}%',
                        onChanged: (val) {
                          setModalState(() => _sliderValue = val);
                          _onSliderChanged(val);
                        },
                        onChangeEnd: _onSliderChangeEnd,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${_sliderValue.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48, // 48x48dp touch targets
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Configuration'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
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
        onRefresh: () async {
          _simulateDataRefresh();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            // M3 responsive layout: single-column on mobile (<600dp), multi-column on desktop (≥840dp).
            final isDesktop = constraints.maxWidth >= 840;
            
            final kpiCards = <Widget>[
              _buildKpiCard(
                context,
                title: 'Current Traffic Split',
                value: '${TrafficSplitMockData.currentSplit.toStringAsFixed(1)}%',
                icon: Icons.tune_rounded,
                status: 'Active',
                statusColor: colorScheme.primary,
              ),
              _buildKpiCard(
                context,
                title: TrafficSplitMockData.metricName,
                value: '${TrafficSplitMockData.currentScore.toStringAsFixed(1)}%',
                icon: Icons.assessment_outlined,
                status: TrafficSplitMockData.qualitativeOutput,
                statusColor: TrafficSplitMockData.qualitativeColor(context),
              ),
              _buildKpiCard(
                context,
                title: 'Optimal Target',
                value: '${TrafficSplitMockData.optimalTarget.toStringAsFixed(1)}%',
                icon: Icons.flag_outlined,
                status: 'Baseline',
                statusColor: colorScheme.secondary,
              ),
            ];

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: kpiCards[0]),
                        const SizedBox(width: 16),
                        Expanded(child: kpiCards[1]),
                        const SizedBox(width: 16),
                        Expanded(child: kpiCards[2]),
                      ],
                    )
                  : Column(
                      children: kpiCards.map((card) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: card,
                      )).toList(),
                    ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: _openConfigBottomSheet,
        tooltip: 'Adjust Traffic Split',
        child: const Icon(Icons.settings_input_component_rounded),
      ),
    );
  }

  /// M3 Elevated Cards Level 2 (3dp) with inline status chip.
  Widget _buildKpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Deep-link drill-down placeholder
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Drilling down into $title...')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
                  Chip(
                    avatar: CircleAvatar(
                      backgroundColor: statusColor.withOpacity(0.2),
                      maxRadius: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                    label: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    backgroundColor: statusColor.withOpacity(0.1),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}