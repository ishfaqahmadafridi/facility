import 'package:flutter/material.dart';

class ActionsRow3 extends StatelessWidget {
  final VoidCallback? onRepeat;
  final VoidCallback? onShare;
  const ActionsRow3({this.onRepeat, this.onShare, super.key});

  @override
  Widget build(BuildContext context) => Row(children: [IconButton(icon: const Icon(Icons.repeat), onPressed: onRepeat), IconButton(icon: const Icon(Icons.share), onPressed: onShare)]);
}
