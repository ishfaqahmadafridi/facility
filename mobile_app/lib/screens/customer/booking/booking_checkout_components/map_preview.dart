import 'package:flutter/material.dart';

class MapPreview extends StatelessWidget {
  final String locationText;
  const MapPreview({required this.locationText, super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: 150,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.map, size: 40, color: Colors.blue), Text(locationText)]),
        ),
      );
}
