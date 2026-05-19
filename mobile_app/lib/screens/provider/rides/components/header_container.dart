import 'package:flutter/material.dart';

class HeaderContainer extends StatelessWidget {
  final bool isRiderMode;
  final ValueChanged<bool> onToggle;
  final String description;

  const HeaderContainer({required this.isRiderMode, required this.onToggle, required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Rider Mode',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Switch(
                value: isRiderMode,
                onChanged: onToggle,
                activeThumbColor: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(description),
        ],
      ),
    );
  }
}
