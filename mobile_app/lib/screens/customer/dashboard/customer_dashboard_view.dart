import 'package:flutter/material.dart';
import 'components/welcome_icon.dart';
import 'components/welcome_text.dart';

class CustomerDashboardView extends StatelessWidget {
  const CustomerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WelcomeIcon(),
          SizedBox(height: 20),
          WelcomeText(),
        ],
      ),
    );
  }
}
