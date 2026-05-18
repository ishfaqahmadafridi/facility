import 'package:flutter/material.dart';
import '../components/rides_list_view.dart' as base;

class RidesListView extends StatelessWidget {
  final List<dynamic> rides;
  final Widget Function(dynamic) itemBuilder;

  const RidesListView({required this.rides, required this.itemBuilder, super.key});

  @override
  Widget build(BuildContext context) => base.RidesListView(rides: rides, itemBuilder: itemBuilder);
}
