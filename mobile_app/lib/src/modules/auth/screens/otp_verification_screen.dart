import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../config/routes.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../theme/app_colors.dart';
import '../../../common_widgets/app_button.dart';
import '../../../common_widgets/loading_overlay.dart';
import '../providers/auth_provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _currentCode = '';

  void _verify() async {
    if (_currentCode.length != 6) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    authProvider.clearError();
    final user = await authProvider.verifyOtp(_currentCode);
    
    if (!mounted) return;
    
    if (user != null) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.roleSelect, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Verification failed'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final phone = authProvider.currentPhone ?? '';

    return LoadingOverlay(
      isLoading: authProvider.isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text('Enter verification code', style: AppTextStyles.display2),
                const SizedBox(height: 12),
                Text(
                  'Code sent to $phone',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 40),
                
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 24),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 56,
                    fieldWidth: 48,
                    activeFillColor: AppColors.bgInput,
                    inactiveFillColor: AppColors.bgInput,
                    selectedFillColor: AppColors.bgInput,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.neutral700,
                    selectedColor: AppColors.primaryLight,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onChanged: (value) {
                    setState(() {
                      _currentCode = value;
                    });
                  },
                  onCompleted: (value) {
                    _verify();
                  },
                ),
                
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      authProvider.requestOtp(phone);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Code resent!')),
                      );
                    },
                    child: const Text('Resend Code'),
                  ),
                ),
                
                const Spacer(),
                
                AppButton(
                  label: 'Verify',
                  onPressed: _currentCode.length == 6 ? _verify : null,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
