import 'package:flutter/material.dart';

class OtpBox extends StatelessWidget {
  const OtpBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade100),
      child: child,
    );
  }
}
