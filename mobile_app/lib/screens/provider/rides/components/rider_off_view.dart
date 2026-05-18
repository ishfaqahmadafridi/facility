import 'package:flutter/material.dart';

class RiderOffView extends StatelessWidget {
  const RiderOffView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        'Rider Mode is off. Turn it on to receive transport requests.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
