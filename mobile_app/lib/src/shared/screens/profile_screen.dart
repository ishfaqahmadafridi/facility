// lib/src/shared/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/routes.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../providers/user_provider.dart';
import '../../modules/auth/providers/auth_provider.dart';
import '../../common_widgets/avatar_widget.dart';
import '../../common_widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AvatarWidget(radius: 50),
                    const SizedBox(height: 16),
                    Text(user.full_name?.isNotEmpty == true ? user.full_name! : 'SUPERAPP User', style: AppTextStyles.h1),
                    const SizedBox(height: 8),
                    Text(user.phone, style: AppTextStyles.bodySecondary),
                    
                    const SizedBox(height: 32),
                    
                    // Wallet
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.neutral700),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.account_balance_wallet, color: AppColors.primary),
                              SizedBox(width: 16),
                              Text('Wallet Balance', style: AppTextStyles.h3),
                            ],
                          ),
                          Text('Rs. 0.00', style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    if (user.roles.contains('PROVIDER')) ...[
                      AppButton(
                        label: 'Switch to Provider Mode',
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.providerHome),
                        variant: ButtonVariant.outlined,
                      ),
                      const SizedBox(height: 16),
                    ],

                    ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Language', style: AppTextStyles.body),
                      trailing: Text(user.preferredLang.toUpperCase(), style: AppTextStyles.label),
                      onTap: () {
                        // Language selection
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Help & Support', style: AppTextStyles.body),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Support
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: AppColors.danger),
                      title: const Text('Logout', style: TextStyle(color: AppColors.danger)),
                      onTap: () async {
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.logout();
                        userProvider.clear();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.splash, (route) => false);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
