// GEN-03298 — Manager Review Card displaying contextual labor cost and staffing impact data.
// Implements M3 Elevated Card (Level 2, 3dp) with status chips, 48x48dp touch targets,
// responsive single-column layout, background polling every 30s, and pull-to-refresh.

import 'dart:async';
import 'package:flutter/material.dart';

/// Mock data model for labor cost and staffing impact.
class LaborCostData {
  final String department;
  final double currentCost;
  final double projectedCost;
  final int currentStaff;
  final int requiredStaff;
  final String status;
  final DateTime lastUpdated;

  const LaborCostData({
    required this.department,
    required this.currentCost,
    required this.projectedCost,
    required this.currentStaff,
    required this.requiredStaff,
    required this.status,
    required this.lastUpdated,
  });
}

/// Mock repository simulating backend API with sub-100ms response latency.
class MockLaborCostRepository {
  static const List<LaborCostData> _mockData = [
    LaborCostData(
      department: 'Engineering',
      currentCost: 145000.00,
      projectedCost: 152000.00,
      currentStaff: 12,
      requiredStaff: 14,
      status: 'Pass',
      lastUpdated: null,
    ),
    LaborCostData(
      department: 'Operations',
      currentCost: 89000.00,
      projectedCost: 89000.00,
      currentStaff: 8,
      requiredStaff: 8,
      status: 'Pass',
      lastUpdated: null,
    ),
    LaborCostData(
      department: 'Customer Success',
      currentCost: 67500.00,
      projectedCost: 72000.00,
      currentStaff: 6,
      requiredStaff: 7,
      status: 'Review',
      lastUpdated: null,
    ),
  ];

  Future<List<LaborCostData>> fetchLaborCostData() async {
    // Simulate sub-100ms network latency
    await Future.delayed(const Duration(milliseconds: 80));
    final now = DateTime.now();
    return _mockData.map((e) => LaborCostData(
      department: e.department,
      currentCost: e.currentCost,
      projectedCost: e.projectedCost,
      currentStaff: e.currentStaff,
      requiredStaff: e.requiredStaff,
      status: e.status,
      lastUpdated: now,
    )).toList();
  }
}

/// Controller managing background polling (30s) and manual refresh state.
class ManagerReviewCardController extends ChangeNotifier {
  final MockLaborCostRepository _repository = MockLaborCostRepository();
  List<LaborCostData> _data = [];
  bool _isLoading = false;
  Timer? _pollingTimer;

  List<LaborCostData> get data => _data;
  bool get isLoading => _isLoading;

  ManagerReviewCardController() {
    loadData();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      loadData(isBackground: true);
    });
  }

  Future<void> loadData({bool isBackground = false}) async {
    if (!isBackground) {
      _isLoading = true;
      notifyListeners();
    }
    try {
      _data = await _repository.fetchLaborCostData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}

/// Main screen widget implementing pull-to-refresh and responsive layout.
class ManagerReviewScreen extends StatefulWidget {
  const ManagerReviewScreen({super.key});

  @override
  State<ManagerReviewScreen> createState() => _ManagerReviewScreenState();
}

class _ManagerReviewScreenState extends State<ManagerReviewScreen> {
  late final ManagerReviewCardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ManagerReviewCardController();
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await _controller.loadData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 840;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Review Console'),
        centerTitle: false,
      ),
      body: _controller.isLoading && _controller.data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (isDesktop) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(24.0),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: _controller.data.length,
                      itemBuilder: (context, index) {
                        return ManagerReviewCard(data: _controller.data[index]);
                      },
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _controller.data.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return ManagerReviewCard(data: _controller.data[index]);
                    },
                  );
                },
              ),
            ),
    );
  }
}

/// M3 Elevated Card (Level 2 - 3dp elevation) displaying labor cost KPIs.
class ManagerReviewCard extends StatelessWidget {
  final LaborCostData data;

  const ManagerReviewCard({super.key, required this.data});

  Color _getStatusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status.toLowerCase()) {
      case 'pass':
        return colorScheme.primary;
      case 'review':
        return colorScheme.tertiary;
      case 'fail':
        return colorScheme.error;
      default:
        return colorScheme.outline;
    }
  }

  void _showDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
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
                '${data.department} - Detailed Analytics',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text('Current Cost: \$${data.currentCost.toStringAsFixed(2)}'),
              Text('Projected Cost: \$${data.projectedCost.toStringAsFixed(2)}'),
              Text('Variance: \$${(data.projectedCost - data.currentCost).toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              Text('Current Staff: ${data.currentStaff}'),
              Text('Required Staff: ${data.requiredStaff}'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48, // 48x48dp touch target
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(height: 16),
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

    return Card(
      elevation: 3.0, // M3 Level 2 elevation
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetailsBottomSheet(context),
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
                      data.department,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Chip(
                    label: Text(
                      data.status,
                      style: TextStyle(
                        color: _getStatusColor(context, data.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: _getStatusColor(context, data.status).withOpacity(0.12),
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _KpiTile(
                      label: 'Labor Cost',
                      value: '\$${(data.currentCost / 1000).toStringAsFixed(1)}k',
                      colorScheme: colorScheme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KpiTile(
                      label: 'Projected',
                      value: '\$${(data.projectedCost / 1000).toStringAsFixed(1)}k',
                      colorScheme: colorScheme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _KpiTile(
                      label: 'Staffing',
                      value: '${data.currentStaff}/${data.requiredStaff}',
                      colorScheme: colorScheme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KpiTile(
                      label: 'Precision',
                      value: '1.0',
                      colorScheme: colorScheme,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (data.lastUpdated != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Updated: ${TimeOfDay.fromDateTime(data.lastUpdated!).format(context)}',
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

class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _KpiTile({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}