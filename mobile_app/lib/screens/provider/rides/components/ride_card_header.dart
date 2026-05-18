import 'package:flutter/material.dart';

class RideCardHeader extends StatelessWidget {
  final String title;
  final Widget trailing;

  const RideCardHeader({required this.title, required this.trailing, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        trailing,
      ],
    );
  }
}
