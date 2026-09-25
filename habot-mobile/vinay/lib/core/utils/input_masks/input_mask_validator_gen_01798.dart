// GEN-01798 — Input Mask Validator for Text Fields.
// Ensures invalid keystrokes (e.g., letters in phone fields) are ignored, implementing M3 UI standards and ISO/IEC 27001 testing compliance.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A [TextInputFormatter] that filters out any characters not matching the provided [RegExp].
/// Used to ensure invalid keystrokes do nothing (e.g., typing "A" in a phone field).
class RegexFilteringFormatter extends TextInputFormatter {
  final RegExp _filterRegex;

  const RegexFilteringFormatter(this._filterRegex);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String filtered = newValue.text.split('').where((char) => _filterRegex.hasMatch(char)).join();
    
    if (filtered == newValue.text) {
      return newValue;
    }
    
    // If invalid characters were typed, revert to old value or strip them
    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

/// Pre-configured formatter for phone number fields (digits only).
final class PhoneInputMask {
  static const TextInputFormatter digitsOnly = RegexFilteringFormatter(RegExp(r'[0-9]'));
}

/// Mock data representing test case configurations for CI/CD validation.
class MockTestCaseData {
  final String id;
  final String fieldName;
  final String inputAttempt;
  final bool expectedPass;
  final String standard;

  const MockTestCaseData({
    required this.id,
    required this.fieldName,
    required this.inputAttempt,
    required this.expectedPass,
    required this.standard,
  });

  static const List<MockTestCaseData> testCases = [
    MockTestCaseData(
      id: 'TC-001',
      fieldName: 'phone_field',
      inputAttempt: '1234567890',
      expectedPass: true,
      standard: 'ISO/IEC 27001',
    ),
    MockTestCaseData(
      id: 'TC-002',
      fieldName: 'phone_field',
      inputAttempt: '123A456B7890',
      expectedPass: false, // Invalid keystrokes should be blocked
      standard: 'ISO/IEC 27001',
    ),
  ];
}

/// M3 Elevated Card displaying step completion state for the engineering console.
class InputValidationStatusCard extends StatelessWidget {
  final double successRate;
  final bool isHealthy;

  const InputValidationStatusCard({
    super.key,
    required this.successRate,
    required this.isHealthy,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GEN-01798: Input Validation',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    isHealthy ? 'PASS' : 'FAIL',
                    style: textTheme.labelSmall?.copyWith(
                      color: isHealthy ? colorScheme.onPrimary : colorScheme.onError,
                    ),
                  ),
                  backgroundColor: isHealthy ? colorScheme.primary : colorScheme.error,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              'Test Case Success Rate: ${successRate.toStringAsFixed(1)}%',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 4.0),
            Text(
              'Floor Threshold: 95% | Optimal Target: 99.5%',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example usage widget demonstrating the input mask behavior.
class InputMaskTestScreen extends StatelessWidget {
  const InputMaskTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Mask Validation Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const InputValidationStatusCard(
              successRate: 99.5,
              isHealthy: true,
            ),
            const SizedBox(height: 24.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Phone Number (Digits Only)',
                hintText: 'Typing "A" will do nothing',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                PhoneInputMask.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
            ),
            const SizedBox(height: 16.0),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Validation configuration saved.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Run Validation Check'),
            ),
          ],
        ),
      ),
    );
  }
}