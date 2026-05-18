import 'package:flutter/material.dart';
import '../components/ride_card_header.dart' as base;

class RideCardHeader extends StatelessWidget {
  final String title;
  final Widget trailing;
  const RideCardHeader({required this.title, required this.trailing, super.key});

  @override
  Widget build(BuildContext context) => base.RideCardHeader(title: title, trailing: trailing);
}
