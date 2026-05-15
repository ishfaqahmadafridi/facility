import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      title: 'KamKaro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const RootScreen(),
    );
  }
}
