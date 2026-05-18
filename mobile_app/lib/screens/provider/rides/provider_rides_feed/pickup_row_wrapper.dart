import 'package:flutter/material.dart';
import '../components/pickup_row.dart' as base;

class PickupRow extends StatelessWidget {
  final String address;
  const PickupRow({required this.address, super.key});

  @override
  Widget build(BuildContext context) => base.PickupRow(address: address);
}
