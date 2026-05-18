import 'package:flutter/material.dart';

class BookingComponent01 extends StatelessWidget {
  const BookingComponent01({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: const [
            Icon(Icons.event_note_outlined),
            SizedBox(width: 8),
            Expanded(child: Text('Booking component 01')),
          ],
        ),
      ),
    );
  }
}
