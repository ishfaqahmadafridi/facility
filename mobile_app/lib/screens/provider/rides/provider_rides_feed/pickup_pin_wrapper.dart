import 'package:flutter/material.dart';
import '../components/pickup_pin_text.dart' as base;

class PickupPinText extends StatelessWidget {
  final dynamic lat;
  final dynamic lng;
  const PickupPinText({this.lat, this.lng, super.key});

  @override
  Widget build(BuildContext context) => base.PickupPinText(lat: lat, lng: lng);
}
