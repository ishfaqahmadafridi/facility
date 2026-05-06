import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/routes.dart';
import '../../../../theme/app_colors.dart';
import '../../../common_widgets/app_button.dart';
import '../../../common_widgets/app_text_field.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/booking_provider.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _addressController = TextEditingController(text: 'Current Location');
  final _notesController = TextEditingController();

  void _requestBooking() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isAuthenticated) {
      Navigator.pushNamed(context, AppRoutes.phoneEntry);
      return;
    }

    final provider = Provider.of<BookingProvider>(context, listen: false);
    
    // Mock Payload
    final success = await provider.requestBooking({
      'vertical': 'HOME_REPAIR',
      'service_type': 'PLUMBING',
      'lat': 31.5204,
      'lng': 74.3587,
      'address': _addressController.text,
      'price': 1500.0,
      'notes': _notesController.text,
    });

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.providerSearching);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            AppTextField(
              label: 'Service Address',
              controller: _addressController,
              prefixIcon: const Icon(Icons.location_on, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Additional Notes (Optional)',
              controller: _notesController,
              hint: 'e.g. Bring extra pipes',
              maxLines: 3,
            ),
            const Spacer(),
            const Text('Fixed Price: Rs. 1500', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            AppButton(
              label: 'Confirm Booking',
              onPressed: _requestBooking,
            ),
          ],
        ),
      ),
    );
  }
}
