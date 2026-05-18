import 'package:flutter/material.dart';

class NoRidesView extends StatelessWidget {
  const NoRidesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        'No ride requests available nearby right now.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
