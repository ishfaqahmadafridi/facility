import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../common_widgets/app_button.dart';
import '../../../common_widgets/app_text_field.dart';
import '../providers/ride_provider.dart';

class RideOfferScreen extends StatefulWidget {
  final String rideId;
  const RideOfferScreen({super.key, required this.rideId});

  @override
  State<RideOfferScreen> createState() => _RideOfferScreenState();
}

class _RideOfferScreenState extends State<RideOfferScreen> {
  final _bidController = TextEditingController();

  void _submitBid() async {
    final amount = double.tryParse(_bidController.text);
    if (amount == null) return;

    final provider = Provider.of<RideProvider>(context, listen: false);
    await provider.placeBid(amount);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bid submitted! Waiting for customer response.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Ride Request')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Estimated Price: Rs. 450', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            const Text('Distance: 8.5 km', style: AppTextStyles.body),
            const SizedBox(height: 24),
            
            AppTextField(
              label: 'Your Bid Amount',
              controller: _bidController,
              keyboardType: TextInputType.number,
              hint: '400',
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Rs.', style: AppTextStyles.bodySecondary)],
                ),
              ),
            ),
            
            const Spacer(),
            AppButton(
              label: 'Submit Bid',
              onPressed: _submitBid,
            ),
          ],
        ),
      ),
    );
  }
}
