import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final int count;
  const NotificationIcon({this.count = 0, super.key});

  @override
  Widget build(BuildContext context) => Stack(alignment: Alignment.topRight, children: [const Icon(Icons.notifications), if (count > 0) CircleAvatar(radius: 8, backgroundColor: Colors.red, child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white)))]);
}
