// GEN-03365 — Mobile Pre-Approval Request Form for Planned Overtime Hours.
// Implements a Material Design 3 single-column form with Elevated Cards, Status Chips,
// Bottom Sheet configuration inputs, Snackbar confirmations, pull-to-refresh, and 30s background polling.

import 'dart:async';
import 'package:flutter/material.dart';

enum OvertimeStatus { draft, pending, approved, rejected }

class OvertimeRequest {
  final String id;
  final String employeeName;
  final DateTime plannedDate;
  final double hours;
  final String reason;
  final OvertimeStatus status;

  const OvertimeRequest({
    required this.id,
    required this.employeeName,
    required this.plannedDate,
    required this.hours,
    required this.reason,
    required this.status,
  });
}

class MockOvertimeRepository {
  static final List<OvertimeRequest> _requests = [
    OvertimeRequest(
      id: 'OT-1001',
      employeeName: 'Vinay Kumar',
      plannedDate: DateTime(2026, 9, 28),
      hours: 4.0,
      reason: 'Critical deployment window for UDF engine release.',
      status: OvertimeStatus.pending,
    ),
    OvertimeRequest(
      id: 'OT-1002',
      employeeName: 'Sarah Chen',
      plannedDate: DateTime(2026, 9, 29),
      hours: 2.5,
      reason: 'Database migration validation and rollback testing.',
      status: OvertimeStatus.approved,
    ),
    OvertimeRequest(
      id: 'OT-1003',
      employeeName: 'Alex Rivera',
      plannedDate: DateTime(2026, 10, 1),
      hours: 6.0,
      reason: 'Weekend load testing for BigQuery streaming pipeline.',
      status: OvertimeStatus.draft,
    ),
  ];

  Future<List<OvertimeRequest>> fetchRequests() async {
    await Future.delayed(const Duration(milliseconds: 25)); // Simulates <100ms floor threshold
    return List.unmodifiable(_requests);
  }

  Future<void> submitRequest(OvertimeRequest request) async {
    await Future.delayed(const Duration(milliseconds: 20));
    _requests.add(request);
  }
}

class OvertimePreApprovalScreen extends StatefulWidget {
  const OvertimePreApprovalScreen({super.key});

  @override
  State<OvertimePreApprovalScreen> createState() => _OvertimePreApprovalScreenState();
}

class _OvertimePreApprovalScreenState extends State<OvertimePreApprovalScreen> {
  final MockOvertimeRepository _repository = MockOvertimeRepository();
  List<OvertimeRequest> _requests = [];
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final data = await _repository.fetchRequests();
      if (mounted) setState(() => _requests = data);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) => _loadData());
  }

  Color _statusColor(OvertimeStatus status, ColorScheme cs) {
    switch (status) {
      case OvertimeStatus.approved:
        return cs.primary;
      case OvertimeStatus.rejected:
        return cs.error;
      case OvertimeStatus.pending:
        return cs.tertiary;
      case OvertimeStatus.draft:
        return cs.outline;
    }
  }

  String _statusLabel(OvertimeStatus status) {
    switch (status) {
      case OvertimeStatus.approved:
        return 'Approved';
      case OvertimeStatus.rejected:
        return 'Rejected';
      case OvertimeStatus.pending:
        return 'Pending';
      case OvertimeStatus.draft:
        return 'Draft';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 840;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overtime Pre-Approval'),
        centerTitle: false,
        actions: [
          IconButton(
            iconSize: 48,
            onPressed: _loadData,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Manual Sync',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showConfigurationBottomSheet(context),
        child: const Icon(Icons.add_rounded),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (isDesktop) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisExtent: 180,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _requests.length,
                      itemBuilder: (context, index) => _buildCard(_requests[index], cs, theme),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _requests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _buildCard(_requests[index], cs, theme),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildCard(OvertimeRequest req, ColorScheme cs, ThemeData theme) {
    return Card(
      elevation: 3,
      surfaceTintColor: cs.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    req.employeeName,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(_statusLabel(req.status)),
                  backgroundColor: _statusColor(req.status, cs).withOpacity(0.12),
                  labelStyle: TextStyle(color: _statusColor(req.status, cs), fontSize: 12),
                  side: BorderSide.none,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('ID: ${req.id}', style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              'Planned: ${req.plannedDate.year}-${req.plannedDate.month.toString().padLeft(2, '0')}-${req.plannedDate.day.toString().padLeft(2, '0')}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text('Hours: ${req.hours}h', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              req.reason,
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showConfigurationBottomSheet(BuildContext context) {
    final hoursController = TextEditingController();
    final reasonController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
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
                        color: Theme.of(ctx).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('New Overtime Request', style: Theme.of(ctx).textTheme.headlineSmall),
                  const SizedBox(height: 24),
                  TextField(
                    controller: hoursController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Planned Hours',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.timer_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: Text('Date: ${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}'),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setModalState(() => selectedDate = picked);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: reasonController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Justification Reason',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () async {
                        final hours = double.tryParse(hoursController.text) ?? 0;
                        if (hours <= 0 || reasonController.text.trim().isEmpty) {
                          Navigator.pop(ctx);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Please fill all fields correctly.'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                          return;
                        }
                        final newReq = OvertimeRequest(
                          id: 'OT-${DateTime.now().millisecondsSinceEpoch % 10000}',
                          employeeName: 'Current User',
                          plannedDate: selectedDate,
                          hours: hours,
                          reason: reasonController.text.trim(),
                          status: OvertimeStatus.pending,
                        );
                        await _repository.submitRequest(newReq);
                        if (ctx.mounted) Navigator.pop(ctx);
                        await _loadData();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Overtime request submitted successfully.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: const Text('Submit Request'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
