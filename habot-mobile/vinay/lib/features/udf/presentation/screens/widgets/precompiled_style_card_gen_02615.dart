// GEN-02615 — Pre-compiled Styling Status Card for Engineering Console.
// Displays step completion state using M3 Elevated Cards, status chips, and responsive single/multi-column layout with mock data.

import 'package:flutter/material.dart';

enum StepCompletionStatus { complete, partial, notComplete }

class PrecompiledStyleStepData {
  final String atomicId;
  final String description;
  final StepCompletionStatus status;
  final double processCompletionRate;
  final DateTime timestamp;

  const PrecompiledStyleStepData({
    required this.atomicId,
    required this.description,
    required this.status,
    required this.processCompletionRate,
    required this.timestamp,
  });
}

final List<PrecompiledStyleStepData> kMockGen02615Steps = [
  PrecompiledStyleStepData(
    atomicId: 'GEN-02615',
    description: 'Pre-compile all styling to reduce mobile rendering times.',
    status: StepCompletionStatus.complete,
    processCompletionRate: 1.0,
    timestamp: DateTime(2026, 9, 25, 10, 30),
  ),
  PrecompiledStyleStepData(
    atomicId: 'GEN-02614',
    description: 'Prior foundational step dependency validation.',
    status: StepCompletionStatus.partial,
    processCompletionRate: 0.65,
    timestamp: DateTime(2026, 9, 25, 10, 28),
  ),
];

class PrecompiledStyleCardGen02615 extends StatelessWidget {
  final PrecompiledStyleStepData data;
  final VoidCallback? onDeepLinkTap;

  const PrecompiledStyleCardGen02615({
    super.key,
    required this.data,
    this.onDeepLinkTap,
  });

  Color _statusColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (data.status) {
      case StepCompletionStatus.complete:
        return colorScheme.primary;
      case StepCompletionStatus.partial:
        return colorScheme.tertiary;
      case StepCompletionStatus.notComplete:
        return colorScheme.error;
    }
  }

  String _statusLabel() {
    switch (data.status) {
      case StepCompletionStatus.complete:
        return 'Complete';
      case StepCompletionStatus.partial:
        return 'Partial';
      case StepCompletionStatus.notComplete:
        return 'Not Complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _statusColor(context);

    return Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onDeepLinkTap,
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
                      data.atomicId,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: statusColor, width: 1.0),
                    ),
                    child: Text(
                      _statusLabel(),
                      style: textTheme.labelLarge?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                data.description,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: data.processCompletionRate.clamp(0.0, 1.0),
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 6.0,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    '${(data.processCompletionRate * 100).toStringAsFixed(0)}%',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Updated: ${data.timestamp.hour.toString().padLeft(2, '0')}:${data.timestamp.minute.toString().padLeft(2, '0')}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EngineeringConsoleDashboardGen02615 extends StatefulWidget {
  const EngineeringConsoleDashboardGen02615({super.key});

  @override
  State<EngineeringConsoleDashboardGen02615> createState() =>
      _EngineeringConsoleDashboardGen02615State();
}

class _EngineeringConsoleDashboardGen02615State
    extends State<EngineeringConsoleDashboardGen02615> {
  late List<PrecompiledStyleStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = List.from(kMockGen02615Steps);
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _steps = List.from(kMockGen02615Steps);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dashboard synced successfully.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Console'),
        centerTitle: false,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final isDesktop = constraints.maxWidth >= 840;

            if (isMobile) {
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: PrecompiledStyleCardGen02615(
                      data: _steps[index],
                      onDeepLinkTap: () {},
                    ),
                  );
                },
              );
            }

            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: isDesktop ? 480.0 : 400.0,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.8,
              ),
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                return PrecompiledStyleCardGen02615(
                  data: _steps[index],
                  onDeepLinkTap: () {},
                );
              },
            );
          },
        ),
      ),
    );
  }
}