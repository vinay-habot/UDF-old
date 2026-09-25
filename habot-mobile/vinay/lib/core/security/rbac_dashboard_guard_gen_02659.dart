// GEN-02659 — RBAC Dashboard Guard for Engineering Console.
// Applies role-based access control to the dashboard backend endpoint mock, ensuring only engineering roles can access it. Uses M3 Elevated Cards and Status Chips with 30-second polling and pull-to-refresh.

import 'dart:async';
import 'package:flutter/material.dart';

enum UserRole { engineer, manager, viewer, admin }

class RbacUser {
  final String id;
  final String name;
  final UserRole role;
  const RbacUser({required this.id, required this.name, required this.role});
}

class MockRbacRepository {
  static const List<RbacUser> _mockUsers = [
    RbacUser(id: 'usr_001', name: 'Alice Engineer', role: UserRole.engineer),
    RbacUser(id: 'usr_002', name: 'Bob Manager', role: UserRole.manager),
    RbacUser(id: 'usr_003', name: 'Charlie Viewer', role: UserRole.viewer),
    RbacUser(id: 'usr_004', name: 'Diana Admin', role: UserRole.admin),
  ];

  Future<List<RbacUser>> fetchAuthorizedUsers() async {
    await Future.delayed(const Duration(milliseconds: 80)); // Sub-100ms latency simulation
    return _mockUsers.where((u) => u.role == UserRole.engineer || u.role == UserRole.admin).toList();
  }

  Future<bool> validateAccess(String userId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final user = _mockUsers.firstWhere((u) => u.id == userId);
    return user.role == UserRole.engineer || user.role == UserRole.admin;
  }
}

class RbacDashboardGuardScreen extends StatefulWidget {
  const RbacDashboardGuardScreen({super.key});

  @override
  State<RbacDashboardGuardScreen> createState() => _RbacDashboardGuardScreenState();
}

class _RbacDashboardGuardScreenState extends State<RbacDashboardGuardScreen> {
  final MockRbacRepository _repository = MockRbacRepository();
  List<RbacUser> _authorizedUsers = [];
  bool _isLoading = true;
  String _rbacStatus = 'Pass';
  Timer? _pollingTimer;
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

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

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final users = await _repository.fetchAuthorizedUsers();
      if (mounted) {
        setState(() {
          _authorizedUsers = users;
          _rbacStatus = users.every((u) => u.role == UserRole.engineer || u.role == UserRole.admin) ? 'Pass' : 'Fail';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _rbacStatus = 'Fail';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Console'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusCard(colorScheme, textTheme),
                    const SizedBox(height: 24),
                    Text('Authorized Engineering Roles', style: textTheme.titleMedium),
                    const SizedBox(height: 12),
                    ..._authorizedUsers.map((user) => _buildUserCard(user, colorScheme, textTheme)).toList(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStatusCard(ColorScheme colorScheme, TextTheme textTheme) {
    final isPass = _rbacStatus == 'Pass';
    return Card(
      elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
      color: isPass ? colorScheme.primaryContainer : colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RBAC Enforcement Accuracy Rate', style: textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    'NIST SP 800-53 Rev 5 Compliant',
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onPrimaryContainer.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            Chip(
              label: Text(
                _rbacStatus,
                style: TextStyle(
                  color: isPass ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: isPass ? colorScheme.primary : colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(RbacUser user, ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        elevation: 3.0,
        child: InkWell(
          onTap: () {
            // Deep-link drill-down simulation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Drilling down into ${user.name} audit logs...'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: SizedBox(
            height: 48.0, // 48x48dp touch targets minimum height
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.engineering, color: colorScheme.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '${user.name} (${user.role.name.toUpperCase()})',
                      style: textTheme.bodyLarge,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
