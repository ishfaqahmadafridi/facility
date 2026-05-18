import 'package:flutter/material.dart';

class PickupPinText extends StatelessWidget {
  final dynamic lat;
  final dynamic lng;
  const PickupPinText({this.lat, this.lng, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Pickup pin: $lat, $lng',
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}
