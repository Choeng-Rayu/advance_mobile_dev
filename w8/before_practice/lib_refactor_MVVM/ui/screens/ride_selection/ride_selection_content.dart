import 'package:flutter/material.dart';
import '../../../model/ride.dart';
import '../../../ui/theme/theme.dart';
import 'ride_selection_view_model.dart';
import 'widgets/rides_selection_header.dart';
import 'widgets/rides_selection_tile.dart';

/// Ride Selection Content - Displays the list of available rides
/// Separated from state management (MVVM approach)
///
/// Receives:
/// - viewModel: RideSelectionViewModel that provides rides and methods
/// - onRideSelected: Callback when a ride is selected
///
/// This widget should NOT be Stateful - it gets notifications from the viewModel
class RideSelectionContent extends StatelessWidget {
  const RideSelectionContent({
    super.key,
    required this.viewModel,
    required this.onRideSelected,
  });

  final RideSelectionViewModel viewModel;
  final Function(Ride) onRideSelected;

  void _onPreferencePressed(BuildContext context) async {
    // TODO: Implement preference modal navigation
    // For now, we'll just use the current preference
  }

  void _onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void _onFilterPressed() {
    // TODO: Implement filtering logic
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
          children: [
            // Header with preference info and controls
            if (viewModel.currentPreference != null)
              RideSelectionHeader(
                ridePreference: viewModel.currentPreference!,
                onBackPressed: () => _onBackPressed(context),
                onFilterPressed: _onFilterPressed,
                onPreferencePressed: () => _onPreferencePressed(context),
              ),
            const SizedBox(height: 16),

            // Rides list
            if (viewModel.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (viewModel.errorMessage != null)
              Expanded(
                child: Center(
                  child: Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else if (viewModel.filteredRides.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No rides available for your preferences'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.filteredRides.length,
                  itemBuilder: (ctx, index) => RideSelectionTile(
                    ride: viewModel.filteredRides[index],
                    onPressed: () =>
                        onRideSelected(viewModel.filteredRides[index]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
