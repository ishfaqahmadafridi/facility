import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/routes.dart';
import '../../../../theme/app_colors.dart';
import '../../../common_widgets/app_button.dart';
import '../../../common_widgets/app_text_field.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/ride_provider.dart';

class PickDropSelectorScreen extends StatefulWidget {
  const PickDropSelectorScreen({super.key});

  @override
  State<PickDropSelectorScreen> createState() => _PickDropSelectorScreenState();
}

class _PickDropSelectorScreenState extends State<PickDropSelectorScreen> {
  final _pickupController = TextEditingController(text: 'Current Location');
  final _dropoffController = TextEditingController();

  void _requestRide() async {
    if (_dropoffController.text.isEmpty) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isAuthenticated) {
      Navigator.pushNamed(context, AppRoutes.phoneEntry);
      return;
    }
    
    final provider = Provider.of<RideProvider>(context, listen: false);
    
    // Mock Payload
    final success = await provider.requestRide({
      'pickup': {'lat': 31.5204, 'lng': 74.3587, 'address': _pickupController.text},
      'dropoff': {'lat': 31.5820, 'lng': 74.3294, 'address': _dropoffController.text},
      'ride_type': 'STANDARD',
      'estimated_price': 450.0,
      'distance_km': 8.5
    });

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.searchingDrivers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            AppTextField(
              label: 'Pickup',
              controller: _pickupController,
              prefixIcon: const Icon(Icons.my_location, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Dropoff',
              controller: _dropoffController,
              hint: 'Search destination',
              prefixIcon: const Icon(Icons.location_on, color: AppColors.danger),
            ),
            const Spacer(),
            AppButton(
              label: 'Confirm & Request Ride',
              onPressed: _requestRide,
            ),
          ],
        ),
      ),
    );
  }
}
