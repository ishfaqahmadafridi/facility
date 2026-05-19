import 'package:flutter/material.dart';

class BookingComponent25 extends StatelessWidget {
  const BookingComponent25({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline),
            SizedBox(width: 8),
            Expanded(child: Text('Booking component 25')),
          ],
        ),
      ),
    );
  }
}
