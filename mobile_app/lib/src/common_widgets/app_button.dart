// lib/src/common_widgets/app_button.dart
// ──────────────────────────────────────────────────────────────────
// Reusable button with loading state and variant support.
// Min height: 52dp (Pakistan low-end Android tap target standard).

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

enum ButtonVariant { primary, outlined, danger, success }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final double? width;
  final IconData? prefixIcon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.width,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = switch (variant) {
      ButtonVariant.primary  => AppColors.primary,
      ButtonVariant.danger   => AppColors.danger,
      ButtonVariant.success  => AppColors.success,
      ButtonVariant.outlined => Colors.transparent,
    };

    final fg = variant == ButtonVariant.outlined
        ? AppColors.primary
        : AppColors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: variant == ButtonVariant.outlined
                ? const BorderSide(color: AppColors.primary, width: 1.5)
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    Icon(prefixIcon, size: 20, color: fg),
                    const SizedBox(width: 8),
                  ],
                  Text(label, style: AppTextStyles.button.copyWith(color: fg)),
                ],
              ),
      ),
    );
  }
}
