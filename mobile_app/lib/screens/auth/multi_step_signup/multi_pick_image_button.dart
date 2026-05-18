import 'package:flutter/material.dart';
import 'dart:io';

class MultiPickImageButton extends StatelessWidget {
  final String label;
  final File? file;
  final VoidCallback onPick;

  const MultiPickImageButton({required this.label, this.file, required this.onPick, super.key});

  @override
  Widget build(BuildContext context) => ElevatedButton(onPressed: onPick, child: Text(file == null ? label : '$label Added'));
}
