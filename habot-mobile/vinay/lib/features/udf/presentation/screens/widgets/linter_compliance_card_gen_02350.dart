// GEN-02350 — Linter Compliance Status Card for Engineering Console.
// Displays UI Compliance Rate (%) using M3 Elevated Card with status chip, 30s background polling, and pull-to-refresh support.

import 'dart:async';
import 'package:flutter/material.dart';

enum _ComplianceStatus { pass, fail, loading }

class _LinterComplianceData {
  final double complianceRate;
  final _ComplianceStatus status;
  final DateTime timestamp;
  final String traceId;

  const _LinterComplianceData({
    required this.complianceRate,
    required this.status,
    required this.timestamp,
    required this.traceId,
  });
}

class _MockLinterRepository {
  static const double floorThreshold = 0.95;

  Future<_LinterComplianceData> fetchCompliance() async {
    await Future.delayed(const Duration(milliseconds: 80));
    final mockRate = 0.97;
    return _LinterComplianceData(
      complianceRate: mockRate,
      status: mockRate >= floorThreshold ? _ComplianceStatus.pass : _ComplianceStatus.fail,
      timestamp: DateTime.now(),
      traceId: 'trace-${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

class LinterComplianceCardGen02350 extends StatefulWidget {
  const LinterComplianceCardGen02350({super.key});

  @override
  State<LinterComplianceCardGen02350> createState() => _LinterComplianceCardGen02350State();
}

class _LinterComplianceCardGen02350State extends State<LinterComplianceCardGen02350> {
  final _MockLinterRepository _repository = _MockLinterRepository();
  _LinterComplianceData? _data;
  Timer? _pollingTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchData());
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    final newData = await _repository.fetchCompliance();
    if (mounted) {
      setState(() {
        _data = newData;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Engineering Console',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'UI Compliance Rate',
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          _buildStatusChip(theme),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_data == null || _isRefreshing)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else ...[
                        Text(
                          '${(_data!.complianceRate * 100).toStringAsFixed(1)}%',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: _data!.status == _ComplianceStatus.pass
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Floor Threshold: ${(_MockLinterRepository.floorThreshold * 100).toStringAsFixed(0)}%',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Divider(color: theme.colorScheme.outlineVariant),
                        const SizedBox(height: 8),
                        _buildInfoRow('Result', _data!.status == _ComplianceStatus.pass ? 'Pass' : 'Fail', theme),
                        _buildInfoRow('Timestamp', _formatTimestamp(_data!.timestamp), theme),
                        _buildInfoRow('Trace ID', _data!.traceId, theme),
                        _buildInfoRow('Standard', 'Material Design 3, WCAG 2.2 AA', theme),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (!isMobile)
                Row(
                  children: [
                    Expanded(child: _buildConfigButton(context, theme)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDeepLinkButton(context, theme)),
                  ],
                )
              else ...[
                _buildConfigButton(context, theme),
                const SizedBox(height: 12),
                _buildDeepLinkButton(context, theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    if (_data == null || _isRefreshing) {
      return Chip(
        label: const Text('Loading'),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      );
    }

    final isPass = _data!.status == _ComplianceStatus.pass;
    return Chip(
      avatar: Icon(
        isPass ? Icons.check_circle : Icons.error,
        size: 18,
        color: isPass ? Colors.green : Colors.red,
      ),
      label: Text(isPass ? 'Pass' : 'Fail'),
      backgroundColor: isPass
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isPass ? Colors.green : Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showConfigBottomSheet(context),
        icon: const Icon(Icons.settings, size: 24),
        label: const Text('Configure Linter'),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }

  Widget _buildDeepLinkButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: FilledButton.tonalIcon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Navigating to detailed drill-down...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        icon: const Icon(Icons.open_in_new, size: 24),
        label: const Text('View Details'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }

  void _showConfigBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Linter Configuration',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const Text(
                'Code linters are configured to highlight undocumented functions in the developer UI.',
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Configuration saved successfully.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Apply Configuration'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }
}