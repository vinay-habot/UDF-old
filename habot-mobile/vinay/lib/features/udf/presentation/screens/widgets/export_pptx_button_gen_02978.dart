// GEN-02978 — Export PPTX Button Widget for Mobile Slide Preview Card.
// Implements a 1-tap Export PPTX button with M3 ElevatedCard, 48x48dp touch targets, Material You dynamic color, and local mock export service.

import 'package:flutter/material.dart';

/// Mock data model representing a slide preview item.
class SlidePreviewModel {
  final String id;
  final String title;
  final String thumbnailUrl;

  const SlidePreviewModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
  });
}

/// Local mock repository simulating backend PPTX export API.
class MockPptxExportRepository {
  static const List<SlidePreviewModel> mockSlides = [
    SlidePreviewModel(
      id: 'slide_001',
      title: 'Q3 Revenue Overview',
      thumbnailUrl: 'assets/mock/slide_001.png',
    ),
    SlidePreviewModel(
      id: 'slide_002',
      title: 'Engineering Metrics',
      thumbnailUrl: 'assets/mock/slide_002.png',
    ),
  ];

  /// Simulates a sub-100ms API response latency for PPTX export.
  Future<bool> exportToPptx(String slideId) async {
    await Future.delayed(const Duration(milliseconds: 85));
    return true;
  }
}

/// A 1-tap Export PPTX button designed for the mobile slide preview card.
/// Follows M3 guidelines: 48x48dp touch targets, ElevatedCard Level 2 (3dp), Material You dynamic color.
class ExportPptxButton extends StatefulWidget {
  final SlidePreviewModel slide;
  final VoidCallback? onExportSuccess;
  final ValueChanged<String>? onExportError;

  const ExportPptxButton({
    super.key,
    required this.slide,
    this.onExportSuccess,
    this.onExportError,
  });

  @override
  State<ExportPptxButton> createState() => _ExportPptxButtonState();
}

class _ExportPptxButtonState extends State<ExportPptxButton> {
  bool _isExporting = false;
  final MockPptxExportRepository _repository = MockPptxExportRepository();

  Future<void> _handleExportTap() async {
    if (_isExporting) return;

    setState(() {
      _isExporting = true;
    });

    try {
      final success = await _repository.exportToPptx(widget.slide.id);
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported ${widget.slide.title} to PPTX successfully.'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
        widget.onExportSuccess?.call();
      } else {
        throw Exception('Export failed');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to export PPTX: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      widget.onExportError?.call(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // M3 responsive layout: single-column on mobile (<600dp)
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Card(
          elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
          surfaceTintColor: colorScheme.surfaceTint,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isMobile ? _buildMobileLayout(theme) : _buildDesktopLayout(theme),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSlideInfo(theme),
        const SizedBox(height: 16.0),
        Center(child: _buildExportButton(theme)),
      ],
    );
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildSlideInfo(theme)),
        const SizedBox(width: 24.0),
        _buildExportButton(theme),
      ],
    );
  }

  Widget _buildSlideInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.slide.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4.0),
        Row(
          children: [
            Icon(Icons.slideshow_outlined, size: 16.0, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4.0),
            Text(
              'ID: ${widget.slide.id}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExportButton(ThemeData theme) {
    return Semantics(
      label: 'Export ${widget.slide.title} to PowerPoint',
      button: true,
      child: SizedBox(
        height: 48.0, // 48x48dp touch targets
        child: FilledButton.icon(
          onPressed: _isExporting ? null : _handleExportTap,
          icon: _isExporting
              ? const SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.picture_as_pdf_outlined, size: 20.0),
          label: Text(_isExporting ? 'Exporting...' : 'Export PPTX'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(48.0, 48.0),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
      ),
    );
  }
}
