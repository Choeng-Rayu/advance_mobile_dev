import 'package:flutter/material.dart';

import '../../../../model/ride.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../theme/theme.dart';

///
/// This tile represents a ride
///
class RideSelectionTile extends StatelessWidget {
  final Ride ride;
  final VoidCallback onPressed;

  const RideSelectionTile({
    super.key,
    required this.ride,
    required this.onPressed,
  });

  String get departure => "From: ${ride.departureLocation}";
  String get arrival => "To: ${ride.arrivalLocation}";
  String get time => "Time: ${DateTimeUtils.formatTime(ride.departureTime)}";
  String get price => "Price: \$${ride.price}";
  String get seats => "Available seats: ${ride.availableSeats}";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: Column(
          children: [
            Text(
              departure,
              style: BlaTextStyles.label.copyWith(color: BlaColors.textLight),
            ),
            Text(
              arrival,
              style: BlaTextStyles.label.copyWith(color: BlaColors.textLight),
            ),
            Text(
              time,
              style: BlaTextStyles.label.copyWith(color: BlaColors.textLight),
            ),
            Text(
              price,
              style: BlaTextStyles.label.copyWith(color: BlaColors.textLight),
            ),
            Text(
              seats,
              style: BlaTextStyles.label.copyWith(color: BlaColors.textLight),
            ),
          ],
        ),
      ),
    );
  }
}
