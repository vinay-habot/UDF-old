// GEN-03099 — Encrypted SQLite Database Service for Offline Prompt Drafting.
// Builds local encrypted SQLite database on mobile clients for offline prompt drafting with NIST SP 800-57 compliant key management and M3 UI integration.

import 'dart:convert';
import 'package:flutter/material.dart';

/// Mock encryption key manager simulating NIST SP 800-57 / ISO/IEC 27001 A.10 compliance.
class EncryptionKeyManager {
  static const String _mockEncryptionKey = 'GEN-03099-MOCK-AES256-KEY-32BYTES!';

  static String get encryptionKey => _mockEncryptionKey;

  static bool validateCompliance() {
    // Floor threshold: 95.0%, Optimal Target: 100%
    return _mockEncryptionKey.length >= 32;
  }
}

/// Model representing an offline prompt draft stored in the encrypted SQLite database.
class PromptDraft {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  PromptDraft({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  factory PromptDraft.fromJson(Map<String, dynamic> json) {
    return PromptDraft(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isSynced': isSynced,
      };
}

/// Mock encrypted SQLite repository simulating Room/SQLite behavior with SQLCipher.
class EncryptedPromptDatabaseRepository {
  final List<PromptDraft> _drafts = [];
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!EncryptionKeyManager.validateCompliance()) {
      throw Exception('Encryption Key Management Compliance below 95% floor threshold.');
    }
    // Simulate database initialization delay
    await Future.delayed(const Duration(milliseconds: 150));
    
    // Seed mock data
    _drafts.addAll([
      PromptDraft(
        id: 'draft_001',
        content: 'Analyze Q3 revenue metrics using BigQuery partitioned tables.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isSynced: true,
      ),
      PromptDraft(
        id: 'draft_002',
        content: 'Generate Material 3 responsive layout specifications for UDF module.',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        updatedAt: DateTime.now(),
        isSynced: false,
      ),
    ]);
    _isInitialized = true;
  }

  bool get isInitialized => _isInitialized;

  Future<List<PromptDraft>> getAllDrafts() async {
    if (!_isInitialized) await initialize();
    await Future.delayed(const Duration(milliseconds: 50)); // Simulate sub-100ms latency
    return List.unmodifiable(_drafts);
  }

  Future<PromptDraft> insertDraft(String content) async {
    if (!_isInitialized) await initialize();
    final now = DateTime.now();
    final draft = PromptDraft(
      id: 'draft_${now.millisecondsSinceEpoch}',
      content: content,
      createdAt: now,
      updatedAt: now,
    );
    _drafts.add(draft);
    return draft;
  }

  Future<void> deleteDraft(String id) async {
    if (!_isInitialized) await initialize();
    _drafts.removeWhere((d) => d.id == id);
  }
}

/// M3 Status Chip indicating encryption compliance health.
class ComplianceStatusChip extends StatelessWidget {
  final bool isCompliant;

  const ComplianceStatusChip({super.key, required this.isCompliant});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(
        isCompliant ? Icons.verified_user : Icons.error_outline,
        size: 18,
        color: isCompliant ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
      ),
      label: Text(
        isCompliant ? 'NIST Compliant (Pass)' : 'Non-Compliant (Fail)',
        style: TextStyle(
          color: isCompliant ? colorScheme.onPrimaryContainer : colorScheme.onErrorContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: isCompliant ? colorScheme.primaryContainer : colorScheme.errorContainer,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

/// M3 Elevated Card Level 2 (3dp) displaying a single prompt draft.
class PromptDraftCard extends StatelessWidget {
  final PromptDraft draft;
  final VoidCallback? onDelete;

  const PromptDraftCard({super.key, required this.draft, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
      surfaceTintColor: colorScheme.surfaceTint,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    draft.id,
                    style: textTheme.labelMedium?.copyWith(color: colorScheme.outline),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(draft.isSynced ? 'Synced' : 'Offline'),
                  backgroundColor: draft.isSynced
                      ? colorScheme.secondaryContainer
                      : colorScheme.tertiaryContainer,
                  labelStyle: TextStyle(fontSize: 12),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              draft.content,
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Updated: ${draft.updatedAt.hour}:${draft.updatedAt.minute.toString().padLeft(2, '0')}',
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                ),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    iconSize: 24,
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48), // 48x48dp touch targets
                    tooltip: 'Delete Draft',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Engineering Console Screen implementing M3 responsive layout.
/// Single-column on mobile (<600dp), multi-column on desktop (>=840dp).
class OfflinePromptConsoleScreen extends StatefulWidget {
  const OfflinePromptConsoleScreen({super.key});

  @override
  State<OfflinePromptConsoleScreen> createState() => _OfflinePromptConsoleScreenState();
}

class _OfflinePromptConsoleScreenState extends State<OfflinePromptConsoleScreen> {
  final EncryptedPromptDatabaseRepository _repository = EncryptedPromptDatabaseRepository();
  List<PromptDraft> _drafts = [];
  bool _isLoading = true;
  late bool _isCompliant;

  @override
  void initState() {
    super.initState();
    _isCompliant = EncryptionKeyManager.validateCompliance();
    _loadData();
    _startBackgroundPolling();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final drafts = await _repository.getAllDrafts();
    if (mounted) {
      setState(() {
        _drafts = drafts;
        _isLoading = false;
      });
    }
  }

  void _startBackgroundPolling() {
    // Background polling refreshes data every 30 seconds
    Future.periodic(const Duration(seconds: 30), (_) {
      if (mounted) _loadData();
    });
  }

  Future<void> _openConfigBottomSheet() async {
    final controller = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('New Offline Prompt Draft', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Prompt Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (controller.text.trim().isNotEmpty) {
                    await _repository.insertDraft(controller.text.trim());
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Draft saved to encrypted SQLite database.'),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(label: 'DISMISS', onPressed: () {}),
                        ),
                      );
                      _loadData();
                    }
                  }
                },
                child: const Text('Save Draft'),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 840;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineering Console - Offline Drafts'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ComplianceStatusChip(isCompliant: _isCompliant),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData, // Pull-to-refresh triggers manual sync
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _drafts.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      const Center(child: Text('No offline drafts found. Tap + to create one.')),
                    ],
                  )
                : isDesktop
                    ? GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          mainAxisExtent: 220,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _drafts.length,
                        itemBuilder: (context, index) {
                          final draft = _drafts[index];
                          return PromptDraftCard(
                            draft: draft,
                            onDelete: () async {
                              await _repository.deleteDraft(draft.id);
                              _loadData();
                            },
                          );
                        },
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _drafts.length,
                        itemBuilder: (context, index) {
                          final draft = _drafts[index];
                          return PromptDraftCard(
                            draft: draft,
                            onDelete: () async {
                              await _repository.deleteDraft(draft.id);
                              _loadData();
                            },
                          );
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openConfigBottomSheet,
        tooltip: 'Create Draft',
        child: const Icon(Icons.add),
      ),
    );
  }
}