import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

// components
import 'booking_checkout_components/checkout_appbar.dart';
import 'booking_checkout_components/booking_title.dart';
import 'booking_checkout_components/section_label.dart';
import 'booking_checkout_components/map_preview.dart';
import 'booking_checkout_components/description_input.dart';
import 'booking_checkout_components/amount_input.dart';
import 'booking_checkout_components/escrow_info_card.dart';
import 'booking_checkout_components/submit_button.dart';
import 'booking_checkout_components/small_spacing.dart';
import 'booking_checkout_components/label_text.dart';
import 'booking_checkout_components/container_box.dart';
import 'booking_checkout_components/dialog_confirm.dart';
import 'booking_checkout_components/icon_map.dart';

class BookingCheckoutView extends StatefulWidget {
  final Map<String, dynamic> providerDetails;

  const BookingCheckoutView({super.key, required this.providerDetails});

  @override
  State<BookingCheckoutView> createState() => _BookingCheckoutViewState();
}

class _BookingCheckoutViewState extends State<BookingCheckoutView> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isProcessing = false;

  void _processBooking() async {
    if (_amountController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isProcessing = true);
    
    final providerUserId = widget.providerDetails['user']?['id'];
    // Assuming backend takes provider_id, price, and description for job creation
    final jobData = {
      'provider_id': providerUserId,
      'category': (widget.providerDetails['categories'] as List).isNotEmpty ? widget.providerDetails['categories'][0] : 'General',
      'price': _amountController.text,
      'description': _descriptionController.text,
      // Map pinning coordinates placeholder
      'latitude': 33.6844, 
      'longitude': 73.0479,
    };

    final success = await ApiService.instance.createJobBooking(jobData);
    
    if (mounted) {
      setState(() => _isProcessing = false);
      if (success) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Booking Confirmed!'),
            content: const Text('Your payment has been held securely in Escrow. Work can now begin.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // close checkout
                  Navigator.pop(context); // close profile -> return to dashboard
                },
                child: const Text('Return Home'),
              )
            ],
          )
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to create booking')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.providerDetails['user'] ?? {};
    final fullName = user['full_name'] ?? 'Provider';

    return Scaffold(
      appBar: const CheckoutAppBar(title: 'Checkout & Escrow'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          BookingTitle(text: 'Booking: $fullName'),
          const SizedBox(height: 24),
          const SectionLabel(text: 'Job Location'),
          const SmallSpacing(height: 8),
          MapPreview(locationText: 'Map Pin Placed: F-8, Islamabad'),
          const SizedBox(height: 24),
          const SectionLabel(text: 'Define Job Scope'),
          const SmallSpacing(height: 8),
          DescriptionInput(controller: _descriptionController),
          const SizedBox(height: 24),
          const SectionLabel(text: 'Agree on Price (PKR)'),
          const SmallSpacing(height: 8),
          AmountInput(controller: _amountController),
          const SizedBox(height: 16),
          EscrowInfoCard(text: 'Funds will be securely held in Escrow and only released when you approve the job is completed.'),
        ]),
      ),
      bottomNavigationBar: SubmitButton(processing: _isProcessing, onPressed: _processBooking),
    );
  }
}
