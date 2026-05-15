import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dual_mode_provider.dart';
import 'customer/customer_home.dart';
import 'provider/provider_home.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Rebuilds the root screen whenever activeMode changes
    return Consumer<DualModeProvider>(
      builder: (context, dualModeProvider, child) {
        if (dualModeProvider.isProviderMode) {
          return const ProviderHome();
        }
        // Default to Customer Mode
        return const CustomerHome();
      },
    );
  }
}
