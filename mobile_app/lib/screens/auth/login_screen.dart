import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'verify_otp_screen.dart';
import 'login/login_controller.dart';
import 'login/login_app_bar.dart';
import 'login/page_padding.dart';
import 'login/welcome_title.dart';
import 'login/spacer_small.dart';
import 'login/welcome_subtitle.dart';
import 'login/spacer_large.dart';
import 'login/phone_text_field.dart';
import 'login/send_otp_button.dart';
import 'login/login_body_column.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  final LoginController _controller = LoginController();

  Future<void> _handleSendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid Pakistan phone number starting with +92')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final success = await _controller.sendOtp(phone);
      if (success) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VerifyOtpScreen(phoneNumber: phone)),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send OTP. Please try again.')),
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
      appBar: const LoginAppBar(),
      body: PagePadding(
        child: LoginBodyColumn(
          children: [
            const WelcomeTitle(),
            const SpacerSmall(),
            const WelcomeSubtitle(),
            const SpacerLarge(),
            PhoneTextField(controller: _phoneController),
            const SpacerLarge(),
            SendOtpButton(isLoading: _isLoading, onPressed: _handleSendOtp),
          ],
        ),
      ),
    );
  }
}
