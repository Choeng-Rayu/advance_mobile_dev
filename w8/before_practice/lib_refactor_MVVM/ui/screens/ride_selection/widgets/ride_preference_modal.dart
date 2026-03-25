import 'package:flutter/material.dart';

import '../../../../model/ride_preference.dart';
import '../../../theme/theme.dart';

/// Ride Preference Modal - Allows editing ride preferences
/// This is a placeholder for now - full implementation TODO
class RidePreferenceModal extends StatefulWidget {
  const RidePreferenceModal({super.key, required this.initialPreference});

  final RidePreference? initialPreference;

  @override
  State<RidePreferenceModal> createState() => _RidePreferenceModalState();
}

class _RidePreferenceModalState extends State<RidePreferenceModal> {
  void onBackSelected() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back icon
            IconButton(
              onPressed: onBackSelected,
              icon: const Icon(Icons.close),
            ),
            SizedBox(height: BlaSpacings.m),

            // Title
            Text(
              "Edit your search",
              style: BlaTextStyles.title.copyWith(color: BlaColors.textNormal),
            ),

            // TODO: Implement full preference editing form
            const Expanded(
              child: Center(child: Text("Preference editing - Coming soon")),
            ),
          ],
        ),
      ),
    );
  }
}
