// GEN-03398 — Benefits & Dependents Home Tiles displaying active plan coverages.
// Implements M3 Elevated Cards (Level 2, 3dp) with status chips, 48x48dp touch targets,
// responsive single-column (<600dp) / multi-column (>=840dp) layout, 30s polling, and pull-to-refresh.

import 'dart:async';
import 'package:flutter/material.dart';

/// Mock data model for a benefit/dependent coverage tile.
class CoverageTileModel {
  final String id;
  final String title;
  final String dependentName;
  final String planType;
  final String status;
  final DateTime effectiveDate;

  const CoverageTileModel({
    required this.id,
    required this.title,
    required this.dependentName,
    required this.planType,
    required this.status,
    required this.effectiveDate,
  });
}

/// Hardcoded mock data simulating backend response for Benefits & Dependents.
const List<CoverageTileModel> _mockCoverages = [
  CoverageTileModel(
    id: 'cov-001',
    title: 'Medical Plan',
    dependentName: 'Self',
    planType: 'PPO Gold',
    status: 'Active',
    effectiveDate: DateTime(2025, 1, 1),
  ),
  CoverageTileModel(
    id: 'cov-002',
    title: 'Dental Plan',
    dependentName: 'Spouse',
    planType: 'DHMO Basic',
    status: 'Active',
    effectiveDate: DateTime(2025, 1, 1),
  ),
  CoverageTileModel(
    id: 'cov-003',
    title: 'Vision Plan',
    dependentName: 'Child - Dependent 1',
    planType: 'VSP Standard',
    status: 'Pending',
    effectiveDate: DateTime(2025, 6, 15),
  ),
  CoverageTileModel(
    id: 'cov-004',
    title: 'Life Insurance',
    dependentName: 'Self',
    planType: 'Group Term 2x Salary',
    status: 'Active',
    effectiveDate: DateTime(2024, 3, 1),
  ),
];

/// Controller managing background polling (30s) and manual refresh state.
class BenefitsDependentsController extends ChangeNotifier {
  List<CoverageTileModel> _coverages = [];
  bool _isLoading = false;
  Timer? _pollingTimer;
  DateTime? _lastSynced;

  List<CoverageTileModel> get coverages => _coverages;
  bool get isLoading => _isLoading;
  DateTime? get lastSynced => _lastSynced;

  BenefitsDependentsController() {
    fetchCoverages();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchCoverages(isBackground: true);
    });
  }

  Future<void> fetchCoverages({bool isBackground = false}) async {
    if (!isBackground) {
      _isLoading = true;
      notifyListeners();
    }

    // Simulate network latency to validate <100ms render target
    await Future.delayed(const Duration(milliseconds: 45));

    _coverages = _mockCoverages;
    _lastSynced = DateTime.now();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}\n
/// Main screen widget implementing the Benefits & Dependents home tiles.
/// Uses LayoutBuilder for M3 responsive breakpoints:
/// Single-column on mobile (<600dp), multi-column on desktop (>=840dp).
class BenefitsDependentsHomeTilesGen03398 extends StatefulWidget {
  const BenefitsDependentsHomeTilesGen03398({super.key});

  @override
  State<BenefitsDependentsHomeTilesGen03398> createState() =>
      _BenefitsDependentsHomeTilesGen03398State();
}

class _BenefitsDependentsHomeTilesGen03398State
    extends State<BenefitsDependentsHomeTilesGen03398> {
  late final BenefitsDependentsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BenefitsDependentsController();
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
    await _controller.fetchCoverages();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Coverage data synced successfully.'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  int _calculateCrossAxisCount(double maxWidth) {
    if (maxWidth >= 840) return 3; // Desktop multi-column
    if (maxWidth >= 600) return 2; // Tablet multi-panel
    return 1; // Mobile single-column
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Benefits & Dependents'),
        centerTitle: false,
        actions: [
          if (_controller.lastSynced != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  'Synced: ${_formatTime(_controller.lastSynced!)}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
        ],
      ),
      body: _controller.isLoading && _controller.coverages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              edgeOffset: kToolbarHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount =
                      _calculateCrossAxisCount(constraints.maxWidth);

                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: crossAxisCount == 1 ? 2.8 : 1.6,
                    ),
                    itemCount: _controller.coverages.length,
                    itemBuilder: (context, index) {
                      final coverage = _controller.coverages[index];
                      return _CoverageElevatedCard(
                        coverage: coverage,
                        onTap: () => _showConfigBottomSheet(context, coverage),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }

  void _showConfigBottomSheet(BuildContext context, CoverageTileModel coverage) {
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
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Configure: ${coverage.title}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Dependent: ${coverage.dependentName}\nPlan: ${coverage.planType}\nStatus: ${coverage.status}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48, // 48x48dp touch target compliance
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close Configuration'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

/// M3 Elevated Card Level 2 (3dp elevation) representing a single coverage tile.
class _CoverageElevatedCard extends StatelessWidget {
  final CoverageTileModel coverage;
  final VoidCallback onTap;

  const _CoverageElevatedCard({
    required this.coverage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = coverage.status.toLowerCase() == 'active';

    return Semantics(
      button: true,
      label: '${coverage.title} for ${coverage.dependentName}, Status: ${coverage.status}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Ink(
          child: Card(
            elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
            surfaceTintColor: theme.colorScheme.surfaceTint,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            clipBehavior: Clip.antiAlias,
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
                          coverage.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // M3 Status Chip for health indicator
                      _StatusChip(isActive: isActive, status: coverage.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    coverage.dependentName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coverage.planType,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Eff: ${coverage.effectiveDate.year}-${coverage.effectiveDate.month.toString().padLeft(2, '0')}-${coverage.effectiveDate.day.toString().padLeft(2, '0')}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Material Design 3 Status Chip implementation.
class _StatusChip extends StatelessWidget {
  final bool isActive;
  final String status;

  const _StatusChip({required this.isActive, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      // Ensuring minimum 48x48dp touch target area if interactive, 
      // but as a visual indicator it maintains standard chip sizing.
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      alignment: Alignment.center,
      child: Text(
        status,
        style: theme.textTheme.labelMedium?.copyWith(
          color: isActive
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onTertiaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}