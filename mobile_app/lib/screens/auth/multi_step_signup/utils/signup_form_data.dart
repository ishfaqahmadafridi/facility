import 'dart:io';

/// Holds all signup form state — extracted from the monolithic screen
/// so the widget only manages UI, not data.
class SignupFormData {
  // Personal
  String fullName = '';
  String gender = 'M';
  String emergencyContact = '';

  // Identity
  String cnic = '';
  File? cnicFront;
  File? cnicBack;
  File? selfie;

  // Role
  String selectedRole = 'CUSTOMER';

  // Provider-specific
  List<String> selectedCategories = [];
  String experience = '';
  String bio = '';
  File? nurseLicense;

  bool get isProvider =>
      selectedRole == 'PROVIDER' || selectedRole == 'BOTH';

  bool get requiresNursePrereq =>
      isProvider && selectedCategories.contains('Nurse');

  /// Converts form data to the API payload map.
  Map<String, dynamic> toApiPayload() {
    final data = <String, dynamic>{
      'full_name': fullName,
      'gender': gender,
      'emergency_contact': emergencyContact,
      'cnic': cnic,
      'role': selectedRole,
    };

    if (isProvider) {
      data['categories'] = selectedCategories;
      data['experience_years'] = int.tryParse(experience) ?? 0;
      data['bio'] = bio;
    }

    return data;
  }

  /// Collects file paths for multipart upload.
  Map<String, String> toFilePaths() {
    final files = <String, String>{};
    if (cnicFront != null) files['cnic_front'] = cnicFront!.path;
    if (cnicBack != null) files['cnic_back'] = cnicBack!.path;
    if (selfie != null) files['selfie'] = selfie!.path;
    if (nurseLicense != null) files['nursing_license'] = nurseLicense!.path;
    return files;
  }
}
