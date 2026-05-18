import 'package:flutter/material.dart';

class ActionsRow2 extends StatelessWidget {
  final VoidCallback? onDecline;
  final VoidCallback? onAccept;
  const ActionsRow2({this.onDecline, this.onAccept, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [Expanded(child: OutlinedButton(onPressed: onDecline, child: const Text('Decline'))), const SizedBox(width: 12), Expanded(child: ElevatedButton(onPressed: onAccept, child: const Text('Accept Offer')))]);
}
