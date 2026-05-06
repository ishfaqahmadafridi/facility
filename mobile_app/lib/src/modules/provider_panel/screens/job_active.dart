import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class JobActiveScreen extends StatelessWidget {
  const JobActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job In Progress')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.timer, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            const Text('Job Started', style: AppTextStyles.h1, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('00:45:12', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.white), textAlign: TextAlign.center),
            
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Mark Job Complete', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
