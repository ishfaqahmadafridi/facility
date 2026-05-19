import 'package:flutter/material.dart';

import '../booking_checkout_components/booking_title.dart';
import '../booking_checkout_components/section_label.dart';
import '../booking_checkout_components/map_preview.dart';
import '../booking_checkout_components/description_input.dart';
import '../booking_checkout_components/amount_input.dart';
import '../booking_checkout_components/escrow_info_card.dart';
import '../booking_checkout_components/small_spacing.dart';

/// The main scrollable form body for the checkout view.
class BookingCheckoutBody extends StatelessWidget {
  final String providerName;
  final TextEditingController descriptionController;
  final TextEditingController amountController;

  const BookingCheckoutBody({
    super.key,
    required this.providerName,
    required this.descriptionController,
    required this.amountController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookingTitle(text: 'Booking: $providerName'),
          const SizedBox(height: 24),
          
          const SectionLabel(text: 'Job Location'),
          const SmallSpacing(height: 8),
          MapPreview(locationText: 'Map Pin Placed: F-8, Islamabad'),
          const SizedBox(height: 24),
          
          const SectionLabel(text: 'Define Job Scope'),
          const SmallSpacing(height: 8),
          DescriptionInput(controller: descriptionController),
          const SizedBox(height: 24),
          
          const SectionLabel(text: 'Agree on Price (PKR)'),
          const SmallSpacing(height: 8),
          AmountInput(controller: amountController),
          const SizedBox(height: 16),
          
          EscrowInfoCard(text: 'Funds will be securely held in Escrow and only released when you approve the job is completed.'),
        ],
      ),
    );
  }
}
