// GEN-02835 — Validator-First Runtime Middleware for JSON Schema Draft-07 Payload Validation.
// Implements a runtime middleware to validate parsed payloads against defined schemas, ensuring sub-100ms latency and M3 status reporting.

import 'dart:convert';

/// Represents the result of a schema validation operation.
class ValidationResultGen02835 {
  final bool isValid;
  final double coveragePercentage;
  final List<String> errors;
  final String qualitativeOutput; // Complete/Partial/Not Complete
  final DateTime timestamp;

  const ValidationResultGen02835({
    required this.isValid,
    required this.coveragePercentage,
    required this.errors,
    required this.qualitativeOutput,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'isValid': isValid,
        'coveragePercentage': coveragePercentage,
        'errors': errors,
        'qualitativeOutput': qualitativeOutput,
        'timestamp': timestamp.toIso8601String(),
      };
}

/// Mock JSON Schema Draft-07 definition for demonstration.
class JsonSchemaDraft07Mock {
  final String name;
  final Map<String, dynamic> properties;
  final List<String> requiredFields;

  const JsonSchemaDraft07Mock({
    required this.name,
    required this.properties,
    required this.requiredFields,
  });
}

/// Core Validator-First Runtime Middleware.
/// Validates all parsed payloads against the defined JSON schema.
class ValidatorMiddlewareGen02835 {
  static const double floorThreshold = 95.0;
  static const double optimalTarget = 100.0;

  final Map<String, JsonSchemaDraft07Mock> _schemaRegistry = {};

  ValidatorMiddlewareGen02835() {
    _initializeMockSchemas();
  }

  void _initializeMockSchemas() {
    _schemaRegistry['UdfPayload'] = const JsonSchemaDraft07Mock(
      name: 'UdfPayload',
      properties: {
        'stepId': {'type': 'string'},
        'status': {'type': 'string', 'enum': ['Complete', 'Partial', 'Not Complete']},
        'metricValue': {'type': 'number'},
      },
      requiredFields: ['stepId', 'status'],
    );
  }

  /// Validates a JSON payload against a registered schema.
  /// Designed for sub-100ms execution on mobile clients.
  ValidationResultGen02835 validate(String schemaName, Map<String, dynamic> payload) {
    final schema = _schemaRegistry[schemaName];
    if (schema == null) {
      return ValidationResultGen02835(
        isValid: false,
        coveragePercentage: 0.0,
        errors: ['Schema not found: $schemaName'],
        qualitativeOutput: 'Not Complete',
        timestamp: DateTime.now(),
      );
    }

    final errors = <String>[];
    int validatedFields = 0;
    int totalRequiredFields = schema.requiredFields.length;

    for (final field in schema.requiredFields) {
      if (!payload.containsKey(field)) {
        errors.add('Missing required field: $field');
      } else {
        validatedFields++;
      }
    }

    for (final entry in payload.entries) {
      if (schema.properties.containsKey(entry.key)) {
        final propDef = schema.properties[entry.key] as Map<String, dynamic>;
        final expectedType = propDef['type'] as String?;
        
        if (expectedType == 'string' && entry.value is! String) {
          errors.add('Invalid type for ${entry.key}: expected String');
        } else if (expectedType == 'number' && entry.value is! num) {
          errors.add('Invalid type for ${entry.key}: expected Number');
        } else {
          if (!schema.requiredFields.contains(entry.key)) {
            validatedFields++;
          }
        }
      }
    }

    final totalFieldsToCheck = schema.properties.length;
    final coverage = totalFieldsToCheck > 0 
        ? (validatedFields / totalFieldsToCheck) * 100.0 
        : 0.0;

    final isValid = errors.isEmpty && coverage >= floorThreshold;
    final qualitativeOutput = isValid 
        ? 'Complete' 
        : (coverage >= 50.0 ? 'Partial' : 'Not Complete');

    return ValidationResultGen02835(
      isValid: isValid,
      coveragePercentage: coverage.clamp(0.0, optimalTarget),
      errors: errors,
      qualitativeOutput: qualitativeOutput,
      timestamp: DateTime.now(),
    );
  }

  /// Middleware interceptor pattern for stream processing.
  Stream<Map<String, dynamic>> interceptStream(
    String schemaName,
    Stream<Map<String, dynamic>> payloadStream,
  ) async* {
    await for (final payload in payloadStream) {
      final result = validate(schemaName, payload);
      if (result.isValid) {
        yield payload;
      } else {
        // In production, this would trigger telemetry/BigQuery streaming
        // and potentially a rollback via Liveness Handshake.
        throw Exception('Validation failed for $schemaName: ${jsonEncode(result.toJson())}');
      }
    }
  }
}

/// Mock data generator for testing the middleware locally without backend.
class MockPayloadGeneratorGen02835 {
  static Map<String, dynamic> generateValidPayload() => {
        'stepId': 'GEN-02835',
        'status': 'Complete',
        'metricValue': 98.5,
      };

  static Map<String, dynamic> generateInvalidPayload() => {
        'stepId': 'GEN-02835',
        // missing 'status'
        'metricValue': 'invalid_type',
      };
}