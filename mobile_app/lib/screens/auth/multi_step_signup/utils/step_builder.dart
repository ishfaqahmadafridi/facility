import 'package:flutter/material.dart';

import 'signup_form_data.dart';
import '../multi_personal_details.dart';
import '../multi_identity.dart';
import '../multi_role_selection.dart';
import '../multi_provider_details.dart';
import '../multi_nurse_prereq.dart';
import '../multi_location_bio.dart';

import '../../../../core/constants/app_constants.dart';
import 'dart:io';

/// Builds the list of [Step]s for the signup stepper.
///
/// Extracted from multi_step_signup_screen to keep the main
/// screen widget focused on orchestration, not step assembly.
class StepBuilder {
  StepBuilder._();

  static List<Step> build({
    required SignupFormData formData,
    required int currentStep,
    required TextEditingController fullNameCtrl,
    required TextEditingController emergencyCtrl,
    required TextEditingController cnicCtrl,
    required TextEditingController experienceCtrl,
    required TextEditingController bioCtrl,
    required void Function(String) onGenderChanged,
    required void Function(String) onRoleChanged,
    required void Function(bool isCamera, void Function(File) onPicked) onPick,
    required void Function(File) onSetFront,
    required void Function(File) onSetBack,
    required void Function(File) onSetSelfie,
    required void Function(File) onSetLicense,
    required void Function(String cat, bool selected) onToggleCategory,
  }) {
    final steps = <Step>[
      Step(
        title: const Text('Personal Details'),
        isActive: currentStep >= 0,
        content: MultiPersonalDetails(
          fullNameCtrl: fullNameCtrl,
          gender: formData.gender,
          onGenderChanged: onGenderChanged,
          emergencyCtrl: emergencyCtrl,
        ),
      ),
      Step(
        title: const Text('Identity (CNIC & Selfie)'),
        isActive: currentStep >= 1,
        content: MultiIdentity(
          cnicCtrl: cnicCtrl,
          cnicFront: formData.cnicFront,
          cnicBack: formData.cnicBack,
          selfie: formData.selfie,
          onPick: onPick,
          onSetFront: onSetFront,
          onSetBack: onSetBack,
          onSetSelfie: onSetSelfie,
        ),
      ),
      Step(
        title: const Text('Role Selection'),
        isActive: currentStep >= 2,
        content: MultiRoleSelection(
          selectedRole: formData.selectedRole,
          onChanged: onRoleChanged,
        ),
      ),
    ];

    if (formData.isProvider) {
      steps.add(
        Step(
          title: const Text('Provider Details'),
          isActive: currentStep >= 3,
          content: MultiProviderDetails(
            availableCategories: AppConstants.availableCategories,
            selectedCategories: formData.selectedCategories,
            onToggleCategory: onToggleCategory,
            experienceCtrl: experienceCtrl,
          ),
        ),
      );

      if (formData.requiresNursePrereq) {
        steps.add(
          Step(
            title: const Text('Nurse Prerequisites'),
            isActive: currentStep >= steps.length,
            content: MultiNursePrereq(
              nurseLicense: formData.nurseLicense,
              onPick: onPick,
              onSetLicense: onSetLicense,
            ),
          ),
        );
      }

      steps.add(
        Step(
          title: const Text('Location & Bio'),
          isActive: currentStep >= steps.length,
          content: MultiLocationBio(
            onSetLocation: () {},
            bioCtrl: bioCtrl,
          ),
        ),
      );
    }

    return steps;
  }
}
