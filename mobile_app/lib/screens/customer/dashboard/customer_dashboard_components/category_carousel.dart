import 'package:flutter/material.dart';

class CategoryCarousel extends StatelessWidget {
  final List<dynamic> categories;
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback? onRidesTap;

  const CategoryCarousel({required this.categories, required this.onSelect, this.selected, this.onRidesTap, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final String catName = cat['name'] ?? 'Unknown';
          var catIcon = Icons.category;
          if (cat['icon'] is IconData) catIcon = cat['icon'];
          final isSelected = selected == catName;

          return GestureDetector(
            onTap: () {
              if (catName == 'Rides') {
                onRidesTap?.call();
                return;
              }
              onSelect(isSelected ? '' : catName);
            },
            child: Container(
              width: 90,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(catIcon, size: 40, color: isSelected ? Colors.white : Colors.blue), const SizedBox(height: 8), Text(catName, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87))]),
            ),
          );
        },
      ),
    );
  }
}
