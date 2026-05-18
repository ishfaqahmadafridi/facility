import 'package:flutter/material.dart';
import 'dart:io';

class MultiFileStatusText extends StatelessWidget {
  final File? file;
  final String label;
  const MultiFileStatusText({this.file, required this.label, super.key});

  @override
  Widget build(BuildContext context) => Text(file == null ? '$label: not added' : '$label: added');
}
