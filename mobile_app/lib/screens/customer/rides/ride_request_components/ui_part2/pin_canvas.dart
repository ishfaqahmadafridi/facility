import 'package:flutter/material.dart';

class PinCanvas extends StatelessWidget {
  final dynamic pickupPin;
  final dynamic dropoffPin;
  final ValueChanged<dynamic> onPickupChanged;
  final ValueChanged<dynamic> onDropoffChanged;

  const PinCanvas({required this.pickupPin, required this.dropoffPin, required this.onPickupChanged, required this.onDropoffChanged, super.key});

  _PinSelection _selectionFromOffset(Offset localPosition, Size size) {
    final normalizedX = (localPosition.dx / size.width).clamp(0.0, 1.0);
    final normalizedY = (localPosition.dy / size.height).clamp(0.0, 1.0);

    const minLat = 33.63;
    const maxLat = 33.73;
    const minLng = 72.98;
    const maxLng = 73.11;

    final latitude = maxLat - ((maxLat - minLat) * normalizedY);
    final longitude = minLng + ((maxLng - minLng) * normalizedX);

    return _PinSelection(
      latitude: latitude,
      longitude: longitude,
      normalizedOffset: Offset(normalizedX, normalizedY),
    );
  }

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
                      onPickupChanged(_selectionFromOffset(details.localPosition, Size(width, height / 2)));
                    },
                    child: _MapHalf(
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
                      onDropoffChanged(_selectionFromOffset(details.localPosition, Size(width, height / 2)));
                    },
                    child: _MapHalf(
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

class _MapHalf extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final Color color;
  final dynamic pin;

  const _MapHalf({required this.width, required this.height, required this.label, required this.color, required this.pin, super.key});

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
            color.withOpacity(0.16),
            Colors.teal.withOpacity(0.10),
          ],
        ),
      ),
      child: Stack(
        children: [
          CustomPaint(size: Size(width, height), painter: _GridPainter(color: color.withOpacity(0.22))),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
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
            child: Text('Tap anywhere to place a pin', style: TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;

  const _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    for (var i = 1; i < 6; i++) {
      final dx = size.width * i / 6;
      final dy = size.height * i / 6;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => oldDelegate.color != color;
}

class _PinSelection {
  final double latitude;
  final double longitude;
  final Offset normalizedOffset;

  const _PinSelection({required this.latitude, required this.longitude, required this.normalizedOffset});
}
