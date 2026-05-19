import 'package:flutter/material.dart';

/// Data model representing a selected pin on the map canvas.
class PinSelection {
  final double latitude;
  final double longitude;
  final Offset normalizedOffset;

  const PinSelection({
    required this.latitude,
    required this.longitude,
    required this.normalizedOffset,
  });
}
