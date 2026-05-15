import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dual_mode_provider.dart';

class ProviderHome extends StatelessWidget {
  const ProviderHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Mode'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Switch to Customer',
            onPressed: () {
              context.read<DualModeProvider>().toggleMode();
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Welcome, Provider!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Find jobs, manage your schedule, and check earnings.'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
