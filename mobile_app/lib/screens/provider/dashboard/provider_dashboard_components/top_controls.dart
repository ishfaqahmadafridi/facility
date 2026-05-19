import 'package:flutter/material.dart';

class TopControls extends StatelessWidget {
  final bool isOnline;
  final double radius;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double?> onRadiusChanged;

  const TopControls({required this.isOnline, required this.radius, required this.onToggle, required this.onRadiusChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              OnlineStatusLabel(isOnline: isOnline),
              Switch(value: isOnline, activeThumbColor: Colors.green, onChanged: onToggle),
            ],
          ),
          RadiusDropdown(value: radius, onChanged: onRadiusChanged),
        ],
      ),
    );
  }
}

class OnlineStatusLabel extends StatelessWidget {
  final bool isOnline;
  const OnlineStatusLabel({required this.isOnline, super.key});

  @override
  Widget build(BuildContext context) => Text(
        isOnline ? 'You are Online' : 'You are Offline',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isOnline ? Colors.green : Colors.grey),
      );
}

class RadiusDropdown extends StatelessWidget {
  final double value;
  final ValueChanged<double?> onChanged;
  const RadiusDropdown({required this.value, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) => DropdownButton<double>(
        value: value,
        underline: Container(),
        items: const [
          DropdownMenuItem(value: 5.0, child: Text('5 km Radius')),
          DropdownMenuItem(value: 15.0, child: Text('15 km Radius')),
          DropdownMenuItem(value: 30.0, child: Text('30 km Radius')),
        ],
        onChanged: onChanged,
      );
}
