import 'package:flutter/material.dart';

class ProviderTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final VoidCallback? onTap;
  const ProviderTile({required this.leading, required this.title, required this.subtitle, required this.trailing, this.onTap, super.key});

  @override
  Widget build(BuildContext context) => ListTile(contentPadding: const EdgeInsets.all(12), leading: leading, title: title, subtitle: subtitle, trailing: trailing, onTap: onTap);
}
