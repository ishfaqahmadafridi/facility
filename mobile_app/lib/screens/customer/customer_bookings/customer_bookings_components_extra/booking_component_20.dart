import 'package:flutter/material.dart';

class BookingComponent20 extends StatelessWidget {
  const BookingComponent20({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.event_available_outlined),
            SizedBox(width: 8),
            Expanded(child: Text('Booking component 20')),
          ],
        ),
      ),
    );
  }
}
