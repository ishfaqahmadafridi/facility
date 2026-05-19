import 'package:flutter/material.dart';
import '../root_screen.dart';
import 'package:facility/services/api_service.dart';
import 'multi_step_signup_screen.dart'; // Replaced role_selection_screen with this

import 'verify_otp_components/header.dart';
import 'verify_otp_components/phone_info.dart';
import 'verify_otp_components/instruction_text.dart';
import 'verify_otp_components/otp_input.dart';
import 'verify_otp_components/verify_button.dart';
import 'verify_otp_components/resend_row.dart';
import 'verify_otp_components/scaffold_padding.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const VerifyOtpScreen({super.key, required this.phoneNumber});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  void _verifyOTP() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await ApiService.instance.verifyOTP(widget.phoneNumber, otp);
      if (result != null) {
        if (!mounted) return;
        
        // result['is_new_user'] identifies if we need onboard
        if (result['is_new_user'] == true) {
           Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MultiStepSignupScreen()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const RootScreen()),
            (route) => false,
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const VerifyHeader(title: 'Verify OTP'),
      body: ScaffoldPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PhoneInfo(phoneNumber: widget.phoneNumber),
            const SizedBox(height: 24),
            const InstructionText(text: 'Enter the 6-digit code sent to your phone.'),
            const SizedBox(height: 20),
            OtpInput(controller: _otpController),
            const SizedBox(height: 20),
            ResendRow(onResend: () async {
              // minimal resend action: call API if available
              try {
                await ApiService.instance.sendOTP(widget.phoneNumber);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP resent')));
              } catch (_) {}
            }),
            const SizedBox(height: 20),
            VerifyButton(isLoading: _isLoading, onPressed: _verifyOTP),
          ],
        ),
      ),
    );
  }
}
