// GEN-02394 — Read-only contact cards with direct Call/Email action buttons.
// Implements M3 Elevated Cards (Level 2, 3dp), responsive single/multi-column layout, 48x48dp touch targets, Material You dynamic color, and local mock data.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Mock data model for contact information.
class ContactInfo {
  final String id;
  final String name;
  final String role;
  final String email;
  final String phone;
  final String avatarUrl;
  final bool isCompliant;

  const ContactInfo({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.isCompliant,
  });
}

/// Hardcoded mock data simulating backend response.
const List<ContactInfo> kMockContacts = [
  ContactInfo(
    id: 'c1',
    name: 'Alice Johnson',
    role: 'Lead Architect',
    email: 'alice.johnson@habot.io',
    phone: '+15550101234',
    avatarUrl: '',
    isCompliant: true,
  ),
  ContactInfo(
    id: 'c2',
    name: 'Bob Smith',
    role: 'Mobile Engineer',
    email: 'bob.smith@habot.io',
    phone: '+15550105678',
    avatarUrl: '',
    isCompliant: true,
  ),
  ContactInfo(
    id: 'c3',
    name: 'Charlie Davis',
    role: 'UX Designer',
    email: 'charlie.davis@habot.io',
    phone: '+15550109012',
    avatarUrl: '',
    isCompliant: false,
  ),
];

/// Responsive wrapper that switches between single-column (<600dp) and multi-column (>=840dp).
class ContactCardsScreen extends StatelessWidget {
  const ContactCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Console'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 840) {
            // Multi-column desktop/tablet layout
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.4,
              ),
              itemCount: kMockContacts.length,
              itemBuilder: (context, index) => ReadOnlyContactCard(contact: kMockContacts[index]),
            );
          } else {
            // Single-column mobile layout
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: kMockContacts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16.0),
              itemBuilder: (context, index) => ReadOnlyContactCard(contact: kMockContacts[index]),
            );
          }
        },
      ),
    );
  }
}

/// Visually rich read-only M3 Elevated Card with inline status chip and action buttons.
class ReadOnlyContactCard extends StatelessWidget {
  final ContactInfo contact;

  const ReadOnlyContactCard({super.key, required this.contact});

  Future<void> _launchUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                    style: TextStyle(color: colorScheme.onPrimaryContainer),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        contact.role,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // M3 Status Chip for health/compliance indicator
                FilterChip(
                  label: Text(contact.isCompliant ? 'Pass' : 'Fail'),
                  selected: contact.isCompliant,
                  onSelected: (_) {}, // Read-only, disabled interaction
                  showCheckmark: false,
                  backgroundColor: contact.isCompliant
                      ? colorScheme.secondaryContainer
                      : colorScheme.errorContainer,
                  selectedColor: contact.isCompliant
                      ? colorScheme.secondaryContainer
                      : colorScheme.errorContainer,
                  labelStyle: TextStyle(
                    color: contact.isCompliant
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onErrorContainer,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Divider(height: 32.0),
            Text(
              contact.email,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),
            Text(
              contact.phone,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            const SizedBox(height: 16.0),
            // Direct Action Buttons with 48x48dp touch targets
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 48.0,
                  width: 48.0,
                  child: IconButton(
                    icon: Icon(Icons.email_outlined, color: colorScheme.primary),
                    tooltip: 'Email ${contact.name}',
                    onPressed: () => _launchUrl('mailto:${contact.email}', context),
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  height: 48.0,
                  width: 48.0,
                  child: IconButton(
                    icon: Icon(Icons.phone_outlined, color: colorScheme.primary),
                    tooltip: 'Call ${contact.name}',
                    onPressed: () => _launchUrl('tel:${contact.phone}', context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}