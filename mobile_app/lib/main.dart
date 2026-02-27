import 'package:flutter/material.dart';

void main() {
  runApp(const FacilityApp());
}

class FacilityApp extends StatelessWidget {
  const FacilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facility',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Service Bidding App - Professional Backend Connected'),
        ),
      ),
    );
  }
}
