import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:facility/services/api_service.dart';
import '../../root_screen.dart';
import '../../../core/utils/snackbar_utils.dart';
import 'utils/signup_form_data.dart';

/// Controller for the multi-step signup flow.
///
/// Owns form data, image picking, and profile submission.
/// The screen widget delegates all logic here.
class SignupController {
  final SignupFormData formData = SignupFormData();
  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;

  /// Picks an image from camera or gallery.
  Future<File?> pickImage(bool isCamera) async {
    final picked = await _picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    return picked != null ? File(picked.path) : null;
  }

  /// Submits the completed profile to the backend.
  Future<bool> submitProfile() async {
    return ApiService.instance.completeProfileMultipart(
      formData.toApiPayload(),
      formData.toFilePaths(),
    );
  }

  /// Navigates to [RootScreen] after successful submission.
  void navigateToRoot(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RootScreen()),
      (route) => false,
    );
  }

  /// Shows an error snackbar.
  void showError(BuildContext context, String message) {
    SnackbarUtils.showError(context, message);
  }
}
