import 'dart:io';
import 'package:flutter/material.dart';

class MultiIdentity extends StatelessWidget {
  final TextEditingController cnicCtrl;
  final File? cnicFront;
  final File? cnicBack;
  final File? selfie;
  final Function(bool, Function(File)) onPick;
  final Function(File) onSetFront;
  final Function(File) onSetBack;
  final Function(File) onSetSelfie;

  const MultiIdentity({required this.cnicCtrl, this.cnicFront, this.cnicBack, this.selfie, required this.onPick, required this.onSetFront, required this.onSetBack, required this.onSetSelfie, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: cnicCtrl, decoration: const InputDecoration(labelText: 'CNIC Number')),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () => onPick(true, onSetFront), child: Text(cnicFront == null ? 'CNIC Front' : 'Front Added')),
            ElevatedButton(onPressed: () => onPick(true, onSetBack), child: Text(cnicBack == null ? 'CNIC Back' : 'Back Added')),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: () => onPick(true, onSetSelfie), child: Text(selfie == null ? 'Take Selfie' : 'Selfie Added')),
      ],
    );
  }
}
