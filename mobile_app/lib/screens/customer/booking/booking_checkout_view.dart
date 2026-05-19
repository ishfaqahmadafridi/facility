import 'package:flutter/material.dart';

import 'booking_checkout_controller.dart';
import 'widgets/booking_checkout_body.dart';
import 'booking_checkout_components/checkout_appbar.dart';
import 'booking_checkout_components/submit_button.dart';

class BookingCheckoutView extends StatefulWidget {
  final Map<String, dynamic> providerDetails;

  const BookingCheckoutView({super.key, required this.providerDetails});

  @override
  State<BookingCheckoutView> createState() => _BookingCheckoutViewState();
}

class _BookingCheckoutViewState extends State<BookingCheckoutView> {
  late final BookingCheckoutController _controller;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = BookingCheckoutController(providerDetails: widget.providerDetails);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleProcessBooking() {
    _controller.processBooking(
      context, 
      _amountController.text, 
      _descriptionController.text, 
      () {
        if (mounted) setState(() {});
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.providerDetails['user'] ?? {};
    final fullName = user['full_name'] ?? 'Provider';

    return Scaffold(
      appBar: const CheckoutAppBar(title: 'Checkout & Escrow'),
      body: BookingCheckoutBody(
        providerName: fullName,
        descriptionController: _descriptionController,
        amountController: _amountController,
      ),
      bottomNavigationBar: SubmitButton(
        processing: _controller.isProcessing, 
        onPressed: _handleProcessBooking,
      ),
    );
  }
}
