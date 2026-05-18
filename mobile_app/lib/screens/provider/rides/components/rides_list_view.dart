import 'package:flutter/material.dart';

class RidesListView extends StatelessWidget {
  final List<dynamic> rides;
  final Widget Function(dynamic) itemBuilder;

  const RidesListView({required this.rides, required this.itemBuilder, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rides.map((r) => itemBuilder(r)).toList(),
    );
  }
}
