import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../providers/dual_mode_provider.dart';

/// Provider profile tab with mode-switch action.
class ProviderProfileTab extends StatelessWidget {
  const ProviderProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.providerPrimary,
          child: Icon(Icons.handyman, size: 50, color: AppColors.textOnPrimary),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text('My Provider Profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 30),
        ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          tileColor: AppColors.surfaceLight,
          leading: const Icon(Icons.swap_horiz, color: AppColors.providerPrimary),
          title: const Text('Switch to Customer Mode',
              style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _handleModeSwitch(context),
        ),
      ],
    );
  }

  Future<void> _handleModeSwitch(BuildContext context) async {
    SnackbarUtils.showInfo(context, AppStrings.switchingMode);
    final dualMode = Provider.of<DualModeProvider>(context, listen: false);
    final success = await dualMode.toggleMode();

    if (context.mounted) {
      SnackbarUtils.hide(context);
      if (!success) {
        SnackbarUtils.showError(context, AppStrings.switchModeFailed);
      }
    }
  }
}
