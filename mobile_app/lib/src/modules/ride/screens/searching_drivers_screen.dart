import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../config/routes.dart';
import '../providers/ride_provider.dart';
import '../widgets/driver_card.dart';

class SearchingDriversScreen extends StatelessWidget {
  const SearchingDriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rideProvider = context.watch<RideProvider>();
    final bids = rideProvider.activeBids;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text('Finding nearby drivers...', style: AppTextStyles.h2),
                  Text('Connecting you with the best matches.', style: AppTextStyles.bodySecondary),
                ],
              ),
            ),
            
            Expanded(
              child: bids.isEmpty
                  ? const Center(child: Text('Waiting for bids...', style: AppTextStyles.bodySecondary))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: bids.length,
                      itemBuilder: (context, index) {
                        final bid = bids[index];
                        return DriverCard(
                          driverId: bid.driverId,
                          bidAmount: bid.bidAmount,
                          rating: 4.8, // Mock
                          onAccept: () async {
                            final success = await rideProvider.acceptBid(bid.id);
                            if (success && context.mounted) {
                              Navigator.pushReplacementNamed(context, AppRoutes.rideActive);
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
