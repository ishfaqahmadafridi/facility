import 'package:flutter/material.dart';

class MultiProviderDetails extends StatelessWidget {
  final List<String> availableCategories;
  final List<String> selectedCategories;
  final void Function(String, bool) onToggleCategory;
  final TextEditingController experienceCtrl;

  const MultiProviderDetails({required this.availableCategories, required this.selectedCategories, required this.onToggleCategory, required this.experienceCtrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select your skills:'),
        Wrap(
          spacing: 8.0,
          children: availableCategories.map((cat) {
            final selected = selectedCategories.contains(cat);
            return FilterChip(
              label: Text(cat),
              selected: selected,
              onSelected: (sel) => onToggleCategory(cat, sel),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: experienceCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Years of Experience'),
        ),
      ],
    );
  }
}
