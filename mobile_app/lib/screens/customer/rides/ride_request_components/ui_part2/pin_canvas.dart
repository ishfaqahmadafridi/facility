import 'package:flutter/material.dart';

import 'utils/pin_canvas_utils.dart';
import 'widgets/map_half.dart';

/// A UI component for selecting pickup and dropoff coordinates
/// using an interactive mock map canvas.
class PinCanvas extends StatelessWidget {
  final dynamic pickupPin;
  final dynamic dropoffPin;
  final ValueChanged<dynamic> onPickupChanged;
  final ValueChanged<dynamic> onDropoffChanged;

  const PinCanvas({
    super.key,
    required this.pickupPin,
    required this.dropoffPin,
    required this.onPickupChanged,
    required this.onDropoffChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tap to place your pins', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Top area sets pickup, bottom area sets drop-off.'),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              const height = 260.0;

              return Column(
                children: [
                  GestureDetector(
                    onTapDown: (details) {
                      onPickupChanged(
                        PinCanvasUtils.selectionFromOffset(details.localPosition, Size(width, height / 2)),
                      );
                    },
                    child: MapHalf(
                      width: width,
                      height: height / 2,
                      label: 'Pickup Zone',
                      color: Colors.blue,
                      pin: pickupPin,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTapDown: (details) {
                      onDropoffChanged(
                        PinCanvasUtils.selectionFromOffset(details.localPosition, Size(width, height / 2)),
                      );
                    },
                    child: MapHalf(
                      width: width,
                      height: height / 2,
                      label: 'Drop-off Zone',
                      color: Colors.red,
                      pin: dropoffPin,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
