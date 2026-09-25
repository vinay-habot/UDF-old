// GEN-02879 — Mobile Auto-Complete Display and Variable Insertion Widget.
// Implements a Material 3 auto-complete overlay triggered by typing '/' with variable insertion, mock data, 48x48dp touch targets, and responsive single-column layout.

import 'package:flutter/material.dart';

/// Mock data representing available variables for auto-complete insertion.
const List<Map<String, String>> _mockVariables = [
  {'key': '/user_name', 'description': 'Inserts the current user display name'},
  {'key': '/timestamp', 'description': 'Inserts the current ISO-8601 timestamp'},
  {'key': '/device_id', 'description': 'Inserts the mobile device identifier'},
  {'key': '/session_id', 'description': 'Inserts the active session trace ID'},
  {'key': '/task_status', 'description': 'Inserts task completion status metric'},
];

/// A widget that provides a text field with an auto-complete popup
/// triggered specifically when the user types the '/' character.
class MobileAutoCompleteWidgetGen02879 extends StatefulWidget {
  const MobileAutoCompleteWidgetGen02879({super.key});

  @override
  State<MobileAutoCompleteWidgetGen02879> createState() => _MobileAutoCompleteWidgetGen02879State();
}

class _MobileAutoCompleteWidgetGen02879State extends State<MobileAutoCompleteWidgetGen02879> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  List<Map<String, String>> _filteredVariables = [];
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    final selection = _controller.selection;

    if (!selection.isValid) {
      _hideAutoComplete();
      return;
    }

    final cursorPos = selection.baseOffset;
    final textBeforeCursor = text.substring(0, cursorPos);
    final lastSlashIndex = textBeforeCursor.lastIndexOf('/');

    if (lastSlashIndex != -1) {
      final textAfterSlash = textBeforeCursor.substring(lastSlashIndex + 1);
      // If there's a space after the slash, we stop searching
      if (textAfterSlash.contains(' ')) {
        _hideAutoComplete();
        return;
      }
      _searchQuery = textAfterSlash.toLowerCase();
      _showAutoComplete();
    } else {
      _hideAutoComplete();
    }
  }

  void _showAutoComplete() {
    setState(() {
      _filteredVariables = _mockVariables.where((v) {
        final key = v['key']!.substring(1).toLowerCase(); // remove leading '/'
        return key.contains(_searchQuery);
      }).toList();
      _isSearching = true;
    });

    _removeOverlay();

    if (_filteredVariables.isEmpty) {
      _isSearching = false;
      return;
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideAutoComplete() {
    if (_isSearching) {
      setState(() {
        _isSearching = false;
        _filteredVariables = [];
      });
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 4.0),
          child: Material(
            elevation: 3.0, // M3 Elevated Card Level 2 (3dp)
            borderRadius: BorderRadius.circular(12.0),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240.0),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredVariables.length,
                separatorBuilder: (_, __) => const Divider(height: 1.0, indent: 16.0, endIndent: 16.0),
                itemBuilder: (context, index) {
                  final variable = _filteredVariables[index];
                  return _AutoCompleteTile(
                    variableKey: variable['key']!,
                    description: variable['description']!,
                    onTap: () => _insertVariable(variable['key']!),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _insertVariable(String variableKey) {
    final text = _controller.text;
    final selection = _controller.selection;
    final cursorPos = selection.baseOffset;
    final textBeforeCursor = text.substring(0, cursorPos);
    final textAfterCursor = text.substring(cursorPos);
    final lastSlashIndex = textBeforeCursor.lastIndexOf('/');

    final newText = textBeforeCursor.substring(0, lastSlashIndex) + variableKey + ' ' + textAfterCursor;
    final newCursorPos = lastSlashIndex + variableKey.length + 1;

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );

    _hideAutoComplete();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Step Configuration Input',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: "Type '/' to insert a variable...",
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            const SizedBox(height: 16.0),
            // M3 Status Chip indicating step health
            Chip(
              avatar: Icon(Icons.check_circle_outline, size: 18.0, color: Theme.of(context).colorScheme.primary),
              label: const Text('Task Completion Status: Complete'),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual tile for the auto-complete dropdown ensuring 48x48dp touch targets.
class _AutoCompleteTile extends StatelessWidget {
  final String variableKey;
  final String description;
  final VoidCallback onTap;

  const _AutoCompleteTile({
    required this.variableKey,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48.0), // 48x48dp touch target
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                variableKey,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 2.0),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}