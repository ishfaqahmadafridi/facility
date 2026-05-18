import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final String hint;
  const SearchBar({this.hint = 'Search...', super.key});

  @override
  Widget build(BuildContext context) => Container(height: 48, margin: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)), child: Center(child: Text(hint)));
}
