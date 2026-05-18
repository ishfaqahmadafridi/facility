import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final int count;
  const NotificationIcon({this.count = 0, super.key});

  @override
  Widget build(BuildContext context) => Stack(children: [const Icon(Icons.notifications), if (count > 0) Positioned(right: 0, child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)), child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10)) ))]);
}
