import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/dual_mode_provider.dart';

class CustomerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Customer Mode'),
      backgroundColor: Colors.blueAccent,
      actions: [
        IconButton(
          icon: const Icon(Icons.swap_horiz),
          tooltip: 'Switch to Provider',
          onPressed: () {
            context.read<DualModeProvider>().toggleMode();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
