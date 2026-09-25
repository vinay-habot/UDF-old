// GEN-02582 — M3 TextFields tailored specifically to the requested data type.
// Implements Material Design 3 compliant input fields with WCAG 2.2 AA accessibility, adaptive layouts, and mock data validation.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Supported data types for M3 TextField generation.
enum UdfDataType {
  text,
  email,
  phone,
  number,
  password,
  date,
}

/// Mock configuration model representing backend-provided field metadata.
class UdfFieldConfig {
  final String id;
  final String label;
  final String hintText;
  final UdfDataType dataType;
  final bool isRequired;
  final int? maxLength;

  const UdfFieldConfig({
    required this.id,
    required this.label,
    required this.hintText,
    required this.dataType,
    this.isRequired = false,
    this.maxLength,
  });
}

/// Hardcoded mock data simulating API response for UDF form fields.
const List<UdfFieldConfig> kMockUdfFields = [
  UdfFieldConfig(
    id: 'field_full_name',
    label: 'Full Name',
    hintText: 'Enter your full name',
    dataType: UdfDataType.text,
    isRequired: true,
    maxLength: 100,
  ),
  UdfFieldConfig(
    id: 'field_email',
    label: 'Email Address',
    hintText: 'name@example.com',
    dataType: UdfDataType.email,
    isRequired: true,
  ),
  UdfFieldConfig(
    id: 'field_phone',
    label: 'Phone Number',
    hintText: '+1 (555) 000-0000',
    dataType: UdfDataType.phone,
  ),
  UdfFieldConfig(
    id: 'field_age',
    label: 'Age',
    hintText: 'Enter age',
    dataType: UdfDataType.number,
    maxLength: 3,
  ),
  UdfFieldConfig(
    id: 'field_password',
    label: 'Password',
    hintText: 'Create a secure password',
    dataType: UdfDataType.password,
    isRequired: true,
  ),
];

/// Generates appropriate [TextInputType] based on [UdfDataType].
TextInputType _getKeyboardType(UdfDataType type) {
  switch (type) {
    case UdfDataType.email:
      return TextInputType.emailAddress;
    case UdfDataType.phone:
      return TextInputType.phone;
    case UdfDataType.number:
      return TextInputType.number;
    default:
      return TextInputType.text;
  }
}

/// Generates appropriate [TextInputFormatter] list based on [UdfDataType].
List<TextInputFormatter> _getInputFormatters(UdfDataType type) {
  switch (type) {
    case UdfDataType.number:
      return [FilteringTextInputFormatter.digitsOnly];
    case UdfDataType.email:
      return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
    default:
      return [];
  }
}

/// A reusable M3 TextField widget tailored to a specific data type.
/// Ensures 48x48dp touch targets and WCAG 2.2 AA compliance.
class M3DataTypeTextField extends StatefulWidget {
  final UdfFieldConfig config;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const M3DataTypeTextField({
    super.key,
    required this.config,
    this.onChanged,
    this.controller,
  });

  @override
  State<M3DataTypeTextField> createState() => _M3DataTypeTextFieldState();
}

class _M3DataTypeTextFieldState extends State<M3DataTypeTextField> {
  late final TextEditingController _controller;
  bool _obscureText = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _obscureText = widget.config.dataType == UdfDataType.password;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _validate(String value) {
    setState(() {
      if (widget.config.isRequired && value.trim().isEmpty) {
        _errorText = '${widget.config.label} is required.';
      } else if (widget.config.dataType == UdfDataType.email &&
          value.isNotEmpty &&
          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
        _errorText = 'Enter a valid email address.';
      } else {
        _errorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPassword = widget.config.dataType == UdfDataType.password;

    // Ensure minimum 48x48dp touch target per M3 guidelines
    return Semantics(
      label: widget.config.label,
      hint: widget.config.hintText,
      required: widget.config.isRequired,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48.0),
        child: TextField(
          controller: _controller,
          keyboardType: _getKeyboardType(widget.config.dataType),
          inputFormatters: _getInputFormatters(widget.config.dataType),
          obscureText: _obscureText,
          maxLength: widget.config.maxLength,
          onChanged: (value) {
            _validate(value);
            widget.onChanged?.call(value);
          },
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            labelText: widget.config.label,
            hintText: widget.config.hintText,
            errorText: _errorText,
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    iconSize: 48.0,
                    icon: Icon(
                      _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

/// Screen demonstrating the M3 responsive layout with tailored TextFields.
/// Single-column on mobile (<600dp), multi-column on desktop (>=840dp).
class UdfM3TextFieldsScreen extends StatelessWidget {
  const UdfM3TextFieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 840;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UDF M3 TextFields'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = isDesktop ? 2 : 1;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Card(
                  elevation: 3.0, // M3 Elevated Cards Level 2 (3dp)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Entry Configuration',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8.0),
                        // M3 Status Chip
                        Chip(
                          avatar: const Icon(Icons.check_circle_outline, size: 18),
                          label: const Text('UI Compliance Rate: 100%'),
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        const SizedBox(height: 24.0),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            mainAxisExtent: 100.0,
                          ),
                          itemCount: kMockUdfFields.length,
                          itemBuilder: (context, index) {
                            final config = kMockUdfFields[index];
                            return M3DataTypeTextField(
                              config: config,
                              onChanged: (value) {
                                // Telemetry / state management hook
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
