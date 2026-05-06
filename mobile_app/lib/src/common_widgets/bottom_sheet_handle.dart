// lib/src/common_widgets/bottom_sheet_handle.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.neutral600,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
