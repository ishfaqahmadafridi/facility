import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import 'multi_app_bar.dart';
import 'multi_loading_view.dart';
import 'multi_controls_builder.dart';
import 'signup_controller.dart';
import 'utils/step_builder.dart';

/// Multi-step signup wizard.
///
/// All business logic lives in [SignupController].
/// Step assembly lives in [StepBuilder].
/// This widget only orchestrates state + UI.
class MultiStepSignupScreen extends StatefulWidget {
  const MultiStepSignupScreen({super.key});

  @override
  State<MultiStepSignupScreen> createState() => _MultiStepSignupScreenState();
}

class _MultiStepSignupScreenState extends State<MultiStepSignupScreen> {
  final _ctrl = SignupController();
  int _currentStep = 0;

  // Text controllers (owned here for lifecycle management)
  final _fullNameCtrl = TextEditingController();
  final _emergencyCtrl = TextEditingController();
  final _cnicCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> _handleSubmit() async {
    // Sync text controllers → form data
    _ctrl.formData
      ..fullName = _fullNameCtrl.text
      ..emergencyContact = _emergencyCtrl.text
      ..cnic = _cnicCtrl.text
      ..experience = _experienceCtrl.text
      ..bio = _bioCtrl.text;

    setState(() => _ctrl.isLoading = true);
    try {
      final success = await _ctrl.submitProfile();
      if (!mounted) return;

      if (success) {
        _ctrl.navigateToRoot(context);
      } else {
        _ctrl.showError(context, AppStrings.profileCompleteFailed);
      }
    } catch (e) {
      if (!mounted) return;
      _ctrl.showError(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => _ctrl.isLoading = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final steps = StepBuilder.build(
      formData: _ctrl.formData,
      currentStep: _currentStep,
      fullNameCtrl: _fullNameCtrl,
      emergencyCtrl: _emergencyCtrl,
      cnicCtrl: _cnicCtrl,
      experienceCtrl: _experienceCtrl,
      bioCtrl: _bioCtrl,
      onGenderChanged: (v) => setState(() => _ctrl.formData.gender = v),
      onRoleChanged: (v) => setState(() => _ctrl.formData.selectedRole = v),
      onPick: (isCamera, onPicked) async {
        final file = await _ctrl.pickImage(isCamera);
        if (file != null) setState(() => onPicked(file));
      },
      onSetFront: (f) => setState(() => _ctrl.formData.cnicFront = f),
      onSetBack: (f) => setState(() => _ctrl.formData.cnicBack = f),
      onSetSelfie: (f) => setState(() => _ctrl.formData.selfie = f),
      onSetLicense: (f) => setState(() => _ctrl.formData.nurseLicense = f),
      onToggleCategory: (cat, sel) => setState(() {
        sel
            ? _ctrl.formData.selectedCategories.add(cat)
            : _ctrl.formData.selectedCategories.remove(cat);
      }),
    );

    return Scaffold(
      appBar: const MultiAppBar(),
      body: _ctrl.isLoading
          ? const MultiLoadingView()
          : Stepper(
              currentStep: _currentStep,
              steps: steps,
              onStepContinue: () {
                if (_currentStep < steps.length - 1) {
                  setState(() => _currentStep += 1);
                } else {
                  _handleSubmit();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) setState(() => _currentStep -= 1);
              },
              controlsBuilder: (context, details) => MultiControlsBuilder(
                currentStep: _currentStep,
                totalSteps: steps.length,
                onContinue: details.onStepContinue,
                onCancel: details.onStepCancel,
              ),
            ),
    );
  }
}
