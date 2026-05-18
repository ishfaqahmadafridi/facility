import 'package:flutter/material.dart';
import '../components/header_container.dart' as base;

class HeaderContainer extends StatelessWidget {
  final bool isRiderMode;
  final ValueChanged<bool> onToggle;
  final String description;

  const HeaderContainer({required this.isRiderMode, required this.onToggle, required this.description, super.key});

  @override
  Widget build(BuildContext context) => base.HeaderContainer(isRiderMode: isRiderMode, onToggle: onToggle, description: description);
}
