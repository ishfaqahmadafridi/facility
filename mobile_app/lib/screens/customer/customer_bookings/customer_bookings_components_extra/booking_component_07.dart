import 'package:flutter/material.dart';

class BookingComponent07 extends StatelessWidget {
  const BookingComponent07({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: const [
            Icon(Icons.report_gmailerrorred_outlined),
            SizedBox(width: 8),
            Expanded(child: Text('Booking component 07')),
          ],
        ),
      ),
    );
  }
}
