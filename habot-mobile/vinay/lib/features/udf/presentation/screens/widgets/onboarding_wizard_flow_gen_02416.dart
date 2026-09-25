// GEN-02416 — Automated Onboarding Wizard Flow with atomic single-screen steps.
// Breaks down long forms into single-column M3 steps to prevent mobile fatigue, using mock data and responsive layout.

import 'package:flutter/material.dart';

enum StepHealth { good, average, poor }

class OnboardingWizardStep {
  final String id;
  final String title;
  final String description;
  final String inputLabel;
  final StepHealth health;
  final int latencyMs;

  const OnboardingWizardStep({
    required this.id,
    required this.title,
    required this.description,
    required this.inputLabel,
    this.health = StepHealth.good,
    this.latencyMs = 85,
  });
}

const List<OnboardingWizardStep> _mockSteps = [
  OnboardingWizardStep(
    id: 'step_1',
    title: 'Organization Details',
    description: 'Enter your organization name and primary domain.',
    inputLabel: 'Organization Name',
    health: StepHealth.good,
    latencyMs: 45,
  ),
  OnboardingWizardStep(
    id: 'step_2',
    title: 'Admin Profile',
    description: 'Provide the primary administrator contact information.',
    inputLabel: 'Admin Email',
    health: StepHealth.average,
    latencyMs: 120,
  ),
  OnboardingWizardStep(
    id: 'step_3',
    title: 'Security Configuration',
    description: 'Configure two-factor authentication preferences.',
    inputLabel: 'Recovery Phone',
    health: StepHealth.good,
    latencyMs: 60,
  ),
  OnboardingWizardStep(
    id: 'step_4',
    title: 'Workspace Setup',
    description: 'Define default workspace layout and permissions.',
    inputLabel: 'Workspace Name',
    health: StepHealth.poor,
    latencyMs: 310,
  ),
];

class OnboardingWizardFlowGen02416 extends StatefulWidget {
  const OnboardingWizardFlowGen02416({super.key});

  @override
  State<OnboardingWizardFlowGen02416> createState() => _OnboardingWizardFlowGen02416State();
}

class _OnboardingWizardFlowGen02416State extends State<OnboardingWizardFlowGen02416> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (final step in _mockSteps) {
      _controllers[step.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _mockSteps.length - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showCompletionSheet();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showCompletionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text('Onboarding Complete', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('All atomic steps have been validated successfully.'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _healthColor(StepHealth health) {
    switch (health) {
      case StepHealth.good:
        return Colors.green;
      case StepHealth.average:
        return Colors.orange;
      case StepHealth.poor:
        return Colors.red;
    }
  }

  String _healthLabel(StepHealth health) {
    switch (health) {
      case StepHealth.good:
        return 'Good';
      case StepHealth.average:
        return 'Average';
      case StepHealth.poor:
        return 'Poor';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 840;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding Wizard'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) setState(() {});
        },
        child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildStepperHeader(),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mockSteps.length,
            itemBuilder: (context, index) => _buildStepCard(_mockSteps[index]),
          ),
        ),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 280,
          child: _buildSideNavigation(),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _mockSteps.length,
                  itemBuilder: (context, index) => _buildStepCard(_mockSteps[index]),
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideNavigation() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockSteps.length,
      itemBuilder: (context, index) {
        final step = _mockSteps[index];
        final isSelected = index == _currentStep;
        return ListTile(
          selected: isSelected,
          leading: CircleAvatar(
            backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : null,
            foregroundColor: isSelected ? Theme.of(context).colorScheme.onPrimary : null,
            child: Text('${index + 1}'),
          ),
          title: Text(step.title),
          onTap: () {
            setState(() => _currentStep = index);
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        );
      },
    );
  }

  Widget _buildStepperHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: List.generate(_mockSteps.length, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    color: isCompleted || isCurrent
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                if (index < _mockSteps.length - 1) const SizedBox(width: 4),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepCard(OnboardingWizardStep step) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      step.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Chip(
                    avatar: Icon(Icons.circle, size: 12, color: _healthColor(step.health)),
                    label: Text(_healthLabel(step.health)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(step.description, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              TextField(
                controller: _controllers[step.id],
                decoration: InputDecoration(
                  labelText: step.inputLabel,
                  border: const OutlineInputBorder(),
                  filled: true,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildKpiCard('API Latency', '${step.latencyMs} ms', step.latencyMs <= 100 ? Colors.green : Colors.orange),
                  _buildKpiCard('Status', 'Active', Theme.of(context).colorScheme.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, Color indicatorColor) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: indicatorColor, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 48,
              width: 120,
              child: OutlinedButton(
                onPressed: _currentStep > 0 ? _previousStep : null,
                child: const Text('Back'),
              ),
            ),
            SizedBox(
              height: 48,
              width: 120,
              child: FilledButton(
                onPressed: _nextStep,
                child: Text(_currentStep == _mockSteps.length - 1 ? 'Finish' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}