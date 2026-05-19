import 'package:flutter/material.dart';
import 'pin_selection.dart';

/// Utility class for calculating pin positions.
class PinCanvasUtils {
  PinCanvasUtils._();

  /// Converts a local tap offset on the canvas into a normalized geographic coordinate.
  static PinSelection selectionFromOffset(Offset localPosition, Size size) {
    final normalizedX = (localPosition.dx / size.width).clamp(0.0, 1.0);
    final normalizedY = (localPosition.dy / size.height).clamp(0.0, 1.0);

    // Hardcoded bounding box for dummy map
    const minLat = 33.63;
    const maxLat = 33.73;
    const minLng = 72.98;
    const maxLng = 73.11;

    final latitude = maxLat - ((maxLat - minLat) * normalizedY);
    final longitude = minLng + ((maxLng - minLng) * normalizedX);

    return PinSelection(
      latitude: latitude,
      longitude: longitude,
      normalizedOffset: Offset(normalizedX, normalizedY),
    );
  }
}
