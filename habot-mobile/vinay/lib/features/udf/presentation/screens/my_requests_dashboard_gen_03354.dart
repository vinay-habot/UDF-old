// GEN-03354 — My Requests Dashboard Tabs
// Builds the "My Requests" dashboard with tabs listing historical and active tickets using Material Design 3 Elevated Cards, Status Chips, and responsive layout.

import 'package:flutter/material.dart';

enum TicketStatus { active, completed, failed, pending }

class TicketModel {
  final String id;
  final String title;
  final String description;
  final TicketStatus status;
  final DateTime createdAt;

  const TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });
}

const List<TicketModel> _mockTickets = [
  TicketModel(
    id: 'TKT-001',
    title: 'Database Migration Request',
    description: 'Migrate user table to new schema.',
    status: TicketStatus.active,
    createdAt: DateTime(2026, 9, 20),
  ),
  TicketModel(
    id: 'TKT-002',
    title: 'API Endpoint Deprecation',
    description: 'Deprecate v1 auth endpoints.',
    status: TicketStatus.completed,
    createdAt: DateTime(2026, 8, 15),
  ),
  TicketModel(
    id: 'TKT-003',
    title: 'SSL Certificate Renewal',
    description: 'Renew wildcard SSL for habot.io.',
    status: TicketStatus.pending,
    createdAt: DateTime(2026, 9, 24),
  ),
  TicketModel(
    id: 'TKT-004',
    title: 'CI/CD Pipeline Failure',
    description: 'Investigate build timeout on main branch.',
    status: TicketStatus.failed,
    createdAt: DateTime(2026, 9, 22),
  ),
  TicketModel(
    id: 'TKT-005',
    title: 'Storage Bucket Expansion',
    description: 'Increase GCS bucket quota for media assets.',
    status: TicketStatus.active,
    createdAt: DateTime(2026, 9, 18),
  ),
];

class MyRequestsDashboardGen03354 extends StatefulWidget {
  const MyRequestsDashboardGen03354({super.key});

  @override
  State<MyRequestsDashboardGen03354> createState() => _MyRequestsDashboardGen03354State();
}

class _MyRequestsDashboardGen03354State extends State<MyRequestsDashboardGen03354>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TicketModel> get _activeTickets =>
      _mockTickets.where((t) => t.status == TicketStatus.active || t.status == TicketStatus.pending).toList();

  List<TicketModel> get _historicalTickets =>
      _mockTickets.where((t) => t.status == TicketStatus.completed || t.status == TicketStatus.failed).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Historical'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          if (mounted) setState(() {});
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _TicketList(tickets: _activeTickets),
            _TicketList(tickets: _historicalTickets),
          ],
        ),
      ),
    );
  }
}

class _TicketList extends StatelessWidget {
  const _TicketList({required this.tickets});

  final List<TicketModel> tickets;

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return const Center(child: Text('No tickets found.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final int crossAxisCount = isMobile ? 1 : (constraints.maxWidth >= 840 ? 3 : 2);

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: isMobile ? 3.0 : 2.5,
          ),
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            return _TicketCard(ticket: tickets[index]);
          },
        );
      },
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});

  final TicketModel ticket;

  Color _statusColor(TicketStatus status, ColorScheme colorScheme) {
    switch (status) {
      case TicketStatus.active:
        return colorScheme.primary;
      case TicketStatus.completed:
        return colorScheme.tertiary;
      case TicketStatus.failed:
        return colorScheme.error;
      case TicketStatus.pending:
        return colorScheme.secondary;
    }
  }

  String _statusLabel(TicketStatus status) {
    switch (status) {
      case TicketStatus.active:
        return 'Active';
      case TicketStatus.completed:
        return 'Completed';
      case TicketStatus.failed:
        return 'Failed';
      case TicketStatus.pending:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Drill-down for ${ticket.id}')),
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
                      ticket.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Chip(
                    label: Text(
                      _statusLabel(ticket.status),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    backgroundColor: _statusColor(ticket.status, colorScheme).withOpacity(0.2),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                ticket.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                '${ticket.createdAt.year}-${ticket.createdAt.month.toString().padLeft(2, '0')}-${ticket.createdAt.day.toString().padLeft(2, '0')}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
