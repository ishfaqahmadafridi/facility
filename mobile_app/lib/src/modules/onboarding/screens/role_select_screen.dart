import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/routes.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../providers/user_provider.dart';
import '../../../common_widgets/app_button.dart';

class RoleSelectScreen extends StatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  State<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends State<RoleSelectScreen> {
  String? _selectedRole;

  void _continue() {
    if (_selectedRole == 'USER') {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (_selectedRole == 'WORKER') {
      _registerAsProvider();
    }
  }

  Future<void> _registerAsProvider() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.registerAsProvider('1234567890123', 'RIDE');
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.providerHome);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to register as provider')),
      );
    }
  }

  Widget _roleCard(String title, String subtitle, IconData icon, String value) {
    final isSelected = _selectedRole == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = value),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.bgCard,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.neutral700,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.neutral800,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h2),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              const Text('How will you use the app?', style: AppTextStyles.display2),
              const SizedBox(height: 12),
              const Text('You can always change this later in settings.', style: AppTextStyles.body),
              const SizedBox(height: 40),
              
              _roleCard(
                'User',
                'Book rides, hire nurses, request mechanics',
                Icons.person,
                'USER',
              ),
              const SizedBox(height: 16),
              _roleCard(
                'Worker',
                'Earn money by providing your services',
                Icons.work,
                'WORKER',
              ),
              
              const Spacer(),
              AppButton(
                label: 'Continue',
                onPressed: _selectedRole != null ? _continue : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
