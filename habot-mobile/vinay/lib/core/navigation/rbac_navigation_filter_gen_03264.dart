// GEN-03264 — Role-Based Permission Navigation Filter.
// Integrates role-based permission checks to hide restricted navigation tabs using M3 Elevated Cards and responsive layouts.

import 'package:flutter/material.dart';

/// Represents a single navigation tab definition.
class NavigationTabDef {
  final String id;
  final String label;
  final IconData icon;
  final Set<String> allowedRoles;
  final Widget screen;

  const NavigationTabDef({
    required this.id,
    required this.label,
    required this.icon,
    required this.allowedRoles,
    required this.screen,
  });
}

/// Mock RBAC service providing the current user's roles.
class MockRbacService {
  static const Set<String> currentUserRoles = {'admin', 'engineer'};

  static bool hasPermission(Set<String> requiredRoles) {
    return requiredRoles.intersection(currentUserRoles).isNotEmpty;
  }
}

/// Filters navigation tabs based on role-based access control.
List<NavigationTabDef> filterTabsByRole(List<NavigationTabDef> allTabs) {
  return allTabs
      .where((tab) => MockRbacService.hasPermission(tab.allowedRoles))
      .toList();
}

/// Mock navigation tab definitions for the UDF engineering console.
final List<NavigationTabDef> mockAllNavigationTabs = [
  const NavigationTabDef(
    id: 'dashboard',
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    allowedRoles: {'admin', 'engineer', 'viewer'},
    screen: _PlaceholderScreen(title: 'Dashboard'),
  ),
  const NavigationTabDef(
    id: 'rbac_config',
    label: 'RBAC Config',
    icon: Icons.security_outlined,
    allowedRoles: {'admin'},
    screen: _PlaceholderScreen(title: 'RBAC Configuration'),
  ),
  const NavigationTabDef(
    id: 'telemetry',
    label: 'Telemetry',
    icon: Icons.analytics_outlined,
    allowedRoles: {'admin', 'engineer'},
    screen: _PlaceholderScreen(title: 'Telemetry & Metrics'),
  ),
  const NavigationTabDef(
    id: 'billing',
    label: 'Billing',
    icon: Icons.payment_outlined,
    allowedRoles: {'finance_admin'},
    screen: _PlaceholderScreen(title: 'Billing Management'),
  ),
];

/// Main scaffold applying RBAC-filtered bottom navigation with M3 standards.
class RbacFilteredNavigationScaffold extends StatefulWidget {
  const RbacFilteredNavigationScaffold({super.key});

  @override
  State<RbacFilteredNavigationScaffold> createState() =>
      _RbacFilteredNavigationScaffoldState();
}

class _RbacFilteredNavigationScaffoldState
    extends State<RbacFilteredNavigationScaffold> {
  late final List<NavigationTabDef> _visibleTabs;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _visibleTabs = filterTabsByRole(mockAllNavigationTabs);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 840;

    if (_visibleTabs.isEmpty) {
      return Scaffold(
        body: Center(
          child: Card(
            elevation: 3.0, // M3 Elevated Card Level 2 (3dp)
            child: const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text('No navigation permissions available.'),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) =>
                  setState(() => _currentIndex = index),
              labelType: NavigationRailLabelType.all,
              destinations: _visibleTabs
                  .map((tab) => NavigationRailDestination(
                        icon: Icon(tab.icon),
                        label: Text(tab.label),
                      ))
                  .toList(),
            ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _visibleTabs.map((tab) => tab.screen).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) =>
                  setState(() => _currentIndex = index),
              destinations: _visibleTabs
                  .map((tab) => NavigationDestination(
                        icon: Icon(tab.icon),
                        label: tab.label,
                      ))
                  .toList(),
            ),
    );
  }
}

/// Placeholder screen demonstrating M3 status cards and step completion state.
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3.0, // M3 Elevated Card Level 2 (3dp)
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step Health',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: const [
                      Chip(
                        avatar: Icon(Icons.check_circle, size: 18),
                        label: Text('RBAC Enforcement: Pass'),
                      ),
                      Chip(
                        avatar: Icon(Icons.timer, size: 18),
                        label: Text('Latency: <100ms'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 48x48dp touch target compliance
          SizedBox(
            height: 48,
            width: 48,
            child: FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configuration synced successfully.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Icon(Icons.sync),
            ),
          ),
        ],
      ),
    );
  }
}