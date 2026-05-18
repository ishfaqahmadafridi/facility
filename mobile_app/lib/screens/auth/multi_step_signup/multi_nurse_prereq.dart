import 'dart:io';
import 'package:flutter/material.dart';

class MultiNursePrereq extends StatelessWidget {
  final File? nurseLicense;
  final Function(bool, Function(File)) onPick;
  final Function(File) onSetLicense;

  const MultiNursePrereq({this.nurseLicense, required this.onPick, required this.onSetLicense, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: () => onPick(false, onSetLicense), child: Text(nurseLicense == null ? 'Upload Nursing License' : 'License Added')),
        const SizedBox(height: 10),
        const Text('Please upload health declaration as well.'),
      ],
    );
  }
}
