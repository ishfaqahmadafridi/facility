import 'package:flutter/material.dart';

import 'grid_painter.dart';

/// Represents a tappable half of the map canvas.
class MapHalf extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final Color color;
  final dynamic pin;

  const MapHalf({
    super.key,
    required this.width,
    required this.height,
    required this.label,
    required this.color,
    required this.pin,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = pin?.normalizedOffset;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.16),
            Colors.teal.withValues(alpha: 0.10),
          ],
        ),
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: GridPainter(color: color.withValues(alpha: 0.22)),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          if (normalized != null)
            Positioned(
              left: (normalized.dx * width) - 12,
              top: (normalized.dy * height) - 24,
              child: Icon(Icons.place, color: color, size: 28),
            ),
          const Center(
            child: Text(
              'Tap anywhere to place a pin',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
