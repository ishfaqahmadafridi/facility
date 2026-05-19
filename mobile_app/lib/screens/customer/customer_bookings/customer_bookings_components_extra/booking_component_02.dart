import 'package:flutter/material.dart';

class BookingComponent02 extends StatelessWidget {
  const BookingComponent02({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.map_outlined),
            SizedBox(width: 8),
            Expanded(child: Text('Booking component 02')),
          ],
        ),
      ),
    );
  }
}
