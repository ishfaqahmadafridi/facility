import 'package:flutter/material.dart';

class ResendRow extends StatelessWidget {
  const ResendRow({super.key, this.onResend});

  final VoidCallback? onResend;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Didn't receive code? "),
        TextButton(onPressed: onResend, child: const Text('Resend')),
      ],
    );
  }
}
