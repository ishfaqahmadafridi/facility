import 'package:flutter/material.dart';
import '../components/dropoff_row.dart' as base;

class DropoffRow extends StatelessWidget {
  final String address;
  const DropoffRow({required this.address, super.key});

  @override
  Widget build(BuildContext context) => base.DropoffRow(address: address);
}
