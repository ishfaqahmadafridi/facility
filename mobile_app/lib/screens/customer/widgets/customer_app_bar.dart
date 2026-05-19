import 'package:flutter/material.dart';

class CustomerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('KamKaro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text('📍 Current Location: Islamabad', style: TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'CUSTOMER',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
