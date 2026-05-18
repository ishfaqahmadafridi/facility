import 'package:flutter/material.dart';

class ProvidersList extends StatelessWidget {
  final List<dynamic> providers;
  final Widget Function(dynamic) itemBuilder;
  const ProvidersList({required this.providers, required this.itemBuilder, super.key});

  @override
  Widget build(BuildContext context) {
    if (providers.isEmpty) {
      return const Padding(padding: EdgeInsets.all(32.0), child: Center(child: Text('No providers found nearby.', style: TextStyle(color: Colors.grey, fontSize: 16))));
    }

    return ListView.builder(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: providers.length, itemBuilder: (context, index) => itemBuilder(providers[index]));
  }
}
