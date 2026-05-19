import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'providers/dual_mode_provider.dart';
import 'screens/root_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DualModeProvider()),
      ],
      child: const FacilityApp(),
    ),
  );
}

class FacilityApp extends StatelessWidget {
  const FacilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RootScreen(),
    );
  }
}
