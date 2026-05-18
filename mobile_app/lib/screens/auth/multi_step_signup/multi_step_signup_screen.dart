import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/api_service.dart';
import '../../root_screen.dart';
import 'multi_app_bar.dart';
import 'multi_loading_view.dart';
import 'multi_personal_details.dart';
import 'multi_identity.dart';
import 'multi_role_selection.dart';
import 'multi_provider_details.dart';
import 'multi_nurse_prereq.dart';
import 'multi_location_bio.dart';
import 'multi_controls_builder.dart';

class MultiStepSignupScreen extends StatefulWidget {
  const MultiStepSignupScreen({super.key});

  @override
  State<MultiStepSignupScreen> createState() => _MultiStepSignupScreenState();
}

class _MultiStepSignupScreenState extends State<MultiStepSignupScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

  // Form Controllers
  final _fullNameCtrl = TextEditingController();
  final _emergencyContactCtrl = TextEditingController();
  final _cnicCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  String _gender = 'M';
  String _selectedRole = 'CUSTOMER';
  
  // Images
  File? _cnicFront;
  File? _cnicBack;
  File? _selfie;
  File? _nurseLicense;

  // Provider Data
  List<String> _selectedCategories = [];
  final List<String> _availableCategories = ['Plumber', 'Electrician', 'Labour', 'Driver', 'Nurse'];

  final _picker = ImagePicker();

  Future<void> _pickImage(bool isCamera, Function(File) onPicked) async {
    final picked = await _picker.pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (picked != null) {
      setState(() => onPicked(File(picked.path)));
    }
  }

  void _submitProfile() async {
    setState(() => _isLoading = true);
    try {
      final Map<String, dynamic> data = {
        'full_name': _fullNameCtrl.text,
        'gender': _gender,
        'emergency_contact': _emergencyContactCtrl.text,
        'cnic': _cnicCtrl.text,
        'role': _selectedRole,
      };

      if (_selectedRole == 'PROVIDER' || _selectedRole == 'BOTH') {
        data['categories'] = _selectedCategories;
        data['experience_years'] = int.tryParse(_experienceCtrl.text) ?? 0;
        data['bio'] = _bioCtrl.text;
      }

      final Map<String, String> files = {};
      if (_cnicFront != null) files['cnic_front'] = _cnicFront!.path;
      if (_cnicBack != null) files['cnic_back'] = _cnicBack!.path;
      if (_selfie != null) files['selfie'] = _selfie!.path;
      if (_nurseLicense != null) files['nursing_license'] = _nurseLicense!.path;

      final success = await ApiService.instance.completeProfileMultipart(data, files);

      if (success) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const RootScreen()),
          (route) => false,
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to complete profile')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Step> _getSteps() {
    List<Step> steps = [
      Step(
        title: const Text('Personal Details'),
        isActive: _currentStep >= 0,
        content: MultiPersonalDetails(
          fullNameCtrl: _fullNameCtrl,
          gender: _gender,
          onGenderChanged: (v) => setState(() => _gender = v),
          emergencyCtrl: _emergencyContactCtrl,
        ),
      ),
      Step(
        title: const Text('Identity (CNIC & Selfie)'),
        isActive: _currentStep >= 1,
        content: MultiIdentity(
          cnicCtrl: _cnicCtrl,
          cnicFront: _cnicFront,
          cnicBack: _cnicBack,
          selfie: _selfie,
          onPick: _pickImage,
          onSetFront: (f) => setState(() => _cnicFront = f),
          onSetBack: (f) => setState(() => _cnicBack = f),
          onSetSelfie: (f) => setState(() => _selfie = f),
        ),
      ),
      Step(
        title: const Text('Role Selection'),
        isActive: _currentStep >= 2,
        content: MultiRoleSelection(
          selectedRole: _selectedRole,
          onChanged: (val) => setState(() => _selectedRole = val),
        ),
      ),
    ];

    if (_selectedRole == 'PROVIDER' || _selectedRole == 'BOTH') {
      steps.add(
        Step(
          title: const Text('Provider Details'),
          isActive: _currentStep >= 3,
          content: MultiProviderDetails(
            availableCategories: _availableCategories,
            selectedCategories: _selectedCategories,
            onToggleCategory: (cat, sel) => setState(() {
              sel ? _selectedCategories.add(cat) : _selectedCategories.remove(cat);
            }),
            experienceCtrl: _experienceCtrl,
          ),
        ),
      );

      if (_selectedCategories.contains('Nurse')) {
        steps.add(
          Step(
            title: const Text('Nurse Prerequisites'),
            isActive: _currentStep >= steps.length,
            content: MultiNursePrereq(
              nurseLicense: _nurseLicense,
              onPick: _pickImage,
              onSetLicense: (f) => setState(() => _nurseLicense = f),
            ),
          )
        );
      }

      steps.add(
        Step(
          title: const Text('Location & Bio'),
          isActive: _currentStep >= steps.length,
          content: MultiLocationBio(
            onSetLocation: () {},
            bioCtrl: _bioCtrl,
          ),
        )
      );
    }

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps();
    return Scaffold(
      appBar: const MultiAppBar(),
      body: _isLoading 
        ? const MultiLoadingView()
        : Stepper(
            currentStep: _currentStep,
            steps: steps,
            onStepContinue: () {
              if (_currentStep < steps.length - 1) {
                setState(() => _currentStep += 1);
              } else {
                _submitProfile();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              }
            },
            controlsBuilder: (context, details) {
              return MultiControlsBuilder(
                currentStep: _currentStep,
                totalSteps: steps.length,
                onContinue: details.onStepContinue,
                onCancel: details.onStepCancel,
              );
            },
          ),
    );
  }
}
