import 'package:flutter/material.dart';

class PinSummary extends StatelessWidget {
  final String title;
  final Color color;
  final dynamic pin;

  const PinSummary({required this.title, required this.color, this.pin, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.place, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              pin == null
                  ? '$title not set'
                  : '$title: ${pin.latitude.toStringAsFixed(4)}, ${pin.longitude.toStringAsFixed(4)}',
            ),
          ),
        ],
      ),
    );
  }
}
