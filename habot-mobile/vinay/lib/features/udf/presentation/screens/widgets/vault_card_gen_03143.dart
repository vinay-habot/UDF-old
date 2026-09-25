// GEN-03143 — Vault Card with Document List Bottom Sheet.
// Implements tap on a vault card to open the document list sheet on mobile using M3 ElevatedCard and ModalBottomSheet.

import 'package:flutter/material.dart';

/// Mock data model representing a document inside a vault.
class MockDocument {
  final String id;
  final String title;
  final String type;
  final DateTime uploadedAt;

  const MockDocument({
    required this.id,
    required this.title,
    required this.type,
    required this.uploadedAt,
  });
}

/// Mock data model representing a vault.
class MockVault {
  final String id;
  final String name;
  final String description;
  final List<MockDocument> documents;

  const MockVault({
    required this.id,
    required this.name,
    required this.description,
    required this.documents,
  });
}

/// Static mock data for demonstration purposes (satisfies backend/mock data rule).
class VaultMockData {
  static const List<MockVault> vaults = [
    MockVault(
      id: 'vault_001',
      name: 'Financial Records',
      description: 'Q1-Q3 Financial Statements',
      documents: [
        MockDocument(id: 'doc_01', title: 'Q1_Report.pdf', type: 'PDF', uploadedAt: null),
        MockDocument(id: 'doc_02', title: 'Q2_Report.pdf', type: 'PDF', uploadedAt: null),
        MockDocument(id: 'doc_03', title: 'Budget.xlsx', type: 'Spreadsheet', uploadedAt: null),
      ],
    ),
    MockVault(
      id: 'vault_002',
      name: 'Engineering Specs',
      description: 'Architecture & Implementation Governance',
      documents: [
        MockDocument(id: 'doc_04', title: 'System_Design.md', type: 'Markdown', uploadedAt: null),
        MockDocument(id: 'doc_05', title: 'API_Spec.yaml', type: 'YAML', uploadedAt: null),
      ],
    ),
  ];
}

/// A Material 3 compliant Vault Card that opens a document list bottom sheet on tap.
/// Touch targets are enforced at 48x48dp minimum. Elevation is set to 3dp (M3 Level 2).
class VaultCardGen03143 extends StatelessWidget {
  final MockVault vault;

  const VaultCardGen03143({
    super.key,
    required this.vault,
  });

  void _openDocumentListSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (BuildContext context) {
        return _DocumentListSheet(vault: vault);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDocumentListSheet(context),
        // Enforce 48x48dp touch target
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48.0, minWidth: 48.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24.0,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        vault.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  vault.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12.0),
                // M3 Status Chip indicating document count
                Chip(
                  avatar: Icon(
                    Icons.description_outlined,
                    size: 16.0,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  label: Text(
                    '${vault.documents.length} Documents',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  side: BorderSide.none,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The M3 Bottom Sheet displaying the list of documents within a vault.
class _DocumentListSheet extends StatelessWidget {
  final MockVault vault;

  const _DocumentListSheet({required this.vault});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Bottom sheet drag handle
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
              child: Container(
                width: 32.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      vault.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                    // 48x48dp touch target by default in Flutter IconButton
                  ),
                ],
              ),
            ),
                const Divider(height: 1.0),
            Expanded(
              child: vault.documents.isEmpty
                  ? Center(
                      child: Text(
                        'No documents available.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: vault.documents.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1.0,
                        indent: 72.0,
                      ),
                      itemBuilder: (context, index) {
                        final doc = vault.documents[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(
                              _getIconForType(doc.type),
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                          title: Text(
                            doc.title,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                            doc.type,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          onTap: () {
                            // M3 Snackbar for confirmations
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Opening ${doc.title}...'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'spreadsheet':
        return Icons.table_chart_outlined;
      case 'markdown':
        return Icons.text_snippet_outlined;
      case 'yaml':
        return Icons.code_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}

/// A responsive layout wrapper that displays VaultCards in a single-column
/// on mobile (<600dp) and multi-column on desktop/tablet (>=840dp).
class VaultGridGen03143 extends StatelessWidget {
  const VaultGridGen03143({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth >= 840.0 ? 3 : (screenWidth >= 600.0 ? 2 : 1);

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: crossAxisCount == 1 ? 3.5 : 2.0,
      ),
      itemCount: VaultMockData.vaults.length,
      itemBuilder: (context, index) {
        return VaultCardGen03143(vault: VaultMockData.vaults[index]);
      },
    );
  }
}
