import 'package:flutter/material.dart';

class BookingComponent03 extends StatelessWidget {
  const BookingComponent03({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: const [
            Icon(Icons.directions_car_outlined),
            SizedBox(width: 8),
            Expanded(child: Text('Booking component 03')),
          ],
        ),
      ),
    );
  }
}
