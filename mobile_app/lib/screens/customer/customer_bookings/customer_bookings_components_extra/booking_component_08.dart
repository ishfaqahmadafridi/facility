import 'package:flutter/material.dart';

class BookingComponent08 extends StatelessWidget {
  const BookingComponent08({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: const [
            Icon(Icons.thumb_up_off_alt_outlined),
            SizedBox(width: 8),
            Expanded(child: Text('Booking component 08')),
          ],
        ),
      ),
    );
  }
}
