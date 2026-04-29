import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/routes.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../theme/app_colors.dart';
import '../../../common_widgets/app_button.dart';
import '../../../common_widgets/app_text_field.dart';
import '../../../common_widgets/loading_overlay.dart';
import '../providers/auth_provider.dart';

class PhoneEntryScreen extends StatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  State<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends State<PhoneEntryScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    // In production, ensure format is E.164 (+92...)
    final phone = _phoneController.text.trim();
    final formattedPhone = phone.startsWith('+') ? phone : '+92$phone';

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearError();
    
    final success = await authProvider.requestOtp(formattedPhone);
    
    if (!mounted) return;
    
    if (success) {
      Navigator.pushNamed(context, AppRoutes.otpVerification);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Failed to send OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return LoadingOverlay(
      isLoading: authProvider.isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  const Text('Enter your phone number', style: AppTextStyles.display2),
                  const SizedBox(height: 12),
                  const Text(
                    'We will send you a 6-digit verification code.',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 40),
                  
                  AppTextField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    hint: '300 1234567',
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('+92', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Required';
                      if (val.length < 10) return 'Invalid phone number';
                      return null;
                    },
                  ),
                  
                  const Spacer(),
                  
                  AppButton(
                    label: 'Continue',
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
