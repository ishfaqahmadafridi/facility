import 'package:flutter/material.dart';

class RadiusFilter extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<bool> onWomenOnlyChanged;
  final bool womenOnly;

  const RadiusFilter({required this.value, required this.onChanged, required this.onWomenOnlyChanged, this.womenOnly = false, super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Search Radius:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), DropdownButton<double>(value: value, underline: Container(), items: const [DropdownMenuItem(value: 5.0, child: Text('5 km')), DropdownMenuItem(value: 10.0, child: Text('10 km')), DropdownMenuItem(value: 20.0, child: Text('20 km'))], onChanged: (v) => v != null ? onChanged(v) : null)]), SwitchListTile(contentPadding: EdgeInsets.zero, value: womenOnly, activeThumbColor: Colors.pink, title: const Text('Women safety filter'), subtitle: const Text('Female customers can request female providers only.'), onChanged: onWomenOnlyChanged)],
        ),
      );
}
