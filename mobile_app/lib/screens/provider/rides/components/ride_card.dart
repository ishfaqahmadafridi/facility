import 'package:flutter/material.dart';
import 'ride_meta_chips.dart';
import 'pickup_row.dart';
import 'dropoff_row.dart';
import 'pickup_pin_text.dart';
import 'ride_actions_row.dart';
import 'ride_card_header.dart';
import 'fare_text.dart';
import 'card_padding.dart';
import 'chips_wrap.dart';

class RideCard extends StatelessWidget {
  final Map<String, dynamic> ride;
  final void Function(String, num) onCounter;
  final void Function(String) onAccept;

  const RideCard({required this.ride, required this.onCounter, required this.onAccept, super.key});

  @override
  Widget build(BuildContext context) {
    final pickup = ride['pickup_address'] ?? 'Unknown';
    final dropoff = ride['dropoff_address'] ?? 'Unknown';
    final fare = num.tryParse((ride['suggested_fare'] ?? '0').toString()) ?? 0;
    final distance = ride['distance_km'];
    final customer = ride['customer']?['user'] ?? {};
    final customerName = customer['full_name'] ?? customer['phone_number'] ?? 'Customer';

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: CardPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RideCardHeader(title: 'Ride Request', trailing: FareText(fare: fare)),
            const SizedBox(height: 8),
            ChipsWrap(children: [
              // RideMetaChips composes individual chips
              RideMetaChips(customerName: customerName.toString(), distance: distance),
            ]),
            const SizedBox(height: 14),
            PickupRow(address: pickup.toString()),
            const SizedBox(height: 8),
            DropoffRow(address: dropoff.toString()),
            const SizedBox(height: 12),
            PickupPinText(lat: ride['pickup_latitude'], lng: ride['pickup_longitude']),
            const SizedBox(height: 16),
            RideActionsRow(
              rideId: ride['id'].toString(),
              fare: fare,
              onCounter: onCounter,
              onAccept: onAccept,
            ),
          ],
        ),
      ),
    );
  }
}
