import 'package:flutter/material.dart';

/// A Ride Preference Picker widget for selecting user ride preferences
/// NOTE: This widget is deprecated and not currently used in MVVM refactored code.
/// Preferences are now set directly in BlaRidePreferenceModal.
///
/// TODO: Implement full preference picker UI if needed for future use.
@Deprecated('Use BlaRidePreferenceModal instead')
class BlaRidePreferencePicker extends StatelessWidget {
  const BlaRidePreferencePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Ride Preference Picker - Deprecated')),
    );
  }
}
