import 'package:flutter/material.dart';

class DistanceWidget extends StatelessWidget {
  final dynamic distance;
  const DistanceWidget({this.distance, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [const Icon(Icons.location_on, color: Colors.grey, size: 16), Text(' ${distance ?? 'Unknown'} km away')]);
}
