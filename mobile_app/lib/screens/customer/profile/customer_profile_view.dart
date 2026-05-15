import 'package:flutter/material.dart';
import 'components/profile_placeholder.dart';

class CustomerProfileView extends StatelessWidget {
  const CustomerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ProfilePlaceholder(),
    );
  }
}
