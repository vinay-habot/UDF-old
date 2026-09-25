// GEN-02460 — Read vs Unread Typography Styling Widget.
// Applies Material 3 typography styling to differentiate read and unread states using semantic colors, WCAG-compliant contrast, and M3 Elevated Cards with Status Chips.

import 'package:flutter/material.dart';

/// Mock data model representing an item with a read/unread state.
class MessageItem {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime timestamp;

  const MessageItem({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.timestamp,
  });
}

/// Local mock repository providing realistic dummy data.
class MockMessageRepository {
  static List<MessageItem> getMessages() {
    return [
      const MessageItem(
        id: 'msg_001',
        title: 'System Update Available',
        body: 'A new version of the platform has been deployed. Please review the changelog.',
        isRead: false,
        timestamp: null,
      ),
      const MessageItem(
        id: 'msg_002',
        title: 'Pipeline Execution Complete',
        body: 'CI/CD pipeline for module UDF passed all validation checks successfully.',
        isRead: true,
        timestamp: null,
      ),
      const MessageItem(
        id: 'msg_003',
        title: 'Security Alert',
        body: 'Unusual login activity detected from an unrecognized IP address.',
        isRead: false,
        timestamp: null,
      ),
      const MessageItem(
        id: 'msg_004',
        title: 'Weekly Telemetry Report',
        body: 'Your weekly performance metrics are ready for review in the engineering console.',
        isRead: true,
        timestamp: null,
      ),
    ];
  }
}

/// A reusable widget that applies distinct M3 typography styling
/// to differentiate between read and unread message states.
class ReadUnreadTypographyCard extends StatelessWidget {
  final MessageItem item;

  const ReadUnreadTypographyCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;

    // Semantic colors for states ensuring WCAG contrast compliance
    final Color unreadTitleColor = colorScheme.primary;
    final Color readTitleColor = colorScheme.onSurfaceVariant;
    final Color unreadBodyColor = colorScheme.onSurface;
    final Color readBodyColor = colorScheme.onSurface.withOpacity(0.7);

    // Typography differentiation
    final TextStyle titleStyle = item.isRead
        ? (textTheme.titleMedium ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.w400, // Regular weight for read
            color: readTitleColor,
          )
        : (textTheme.titleMedium ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.w700, // Bold weight for unread
            color: unreadTitleColor,
          );

    final TextStyle bodyStyle = item.isRead
        ? (textTheme.bodyMedium ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.w400,
            color: readBodyColor,
          )
        : (textTheme.bodyMedium ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.w500, // Medium weight for unread
            color: unreadBodyColor,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Deep-link drill-down triggered for ${item.id}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          // 48x48dp minimum touch target enforced by InkWell/Card constraints
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
                        item.title,
                        style: titleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // M3 Status Chip for health/state indicators
                    Chip(
                      label: Text(
                        item.isRead ? 'Read' : 'Unread',
                        style: textTheme.labelSmall?.copyWith(
                          color: item.isRead
                              ? colorScheme.onSecondaryContainer
                              : colorScheme.onErrorContainer,
                        ),
                      ),
                      backgroundColor: item.isRead
                          ? colorScheme.secondaryContainer
                          : colorScheme.errorContainer,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  item.body,
                  style: bodyStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Screen implementation demonstrating the typography styling applied
/// across a list of items in a single-column mobile layout.
class ReadUnreadTypographyScreenGen02460 extends StatelessWidget {
  const ReadUnreadTypographyScreenGen02460({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MessageItem> messages = MockMessageRepository.getMessages();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Console - Messages'),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate pull-to-refresh manual sync
          await Future.delayed(const Duration(seconds: 1));
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // M3 responsive layout: single-column on mobile (<600dp), multi-column on desktop (>=840dp)
            final int crossAxisCount = constraints.maxWidth >= 840 ? 2 : 1;

            return ListView.builder(
              itemCount: messages.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final MessageItem item = messages[index];
                
                if (crossAxisCount > 1 && index % 2 == 0) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: ReadUnreadTypographyCard(item: item)),
                      if (index + 1 < messages.length)
                        Expanded(child: ReadUnreadTypographyCard(item: messages[index + 1]))
                      else
                        const Expanded(child: SizedBox.shrink()),
                    ],
                  );
                } else if (crossAxisCount > 1) {
                  return const SizedBox.shrink();
                }

                return ReadUnreadTypographyCard(item: item);
              },
            );
          },
        ),
      ),
    );
  }
}
