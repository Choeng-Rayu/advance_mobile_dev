import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/ride/rides_repository.dart';
import 'ride_selection_content.dart';
import 'ride_selection_view_model.dart';

/// Ride Selection Screen - Shows available rides for selected preferences
/// Uses Provider pattern to manage state
class RideSelectionScreen extends StatefulWidget {
  final String departureLocation;
  final String arrivalLocation;
  final DateTime departureDate;

  const RideSelectionScreen({
    super.key,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.departureDate,
  });

  @override
  State<RideSelectionScreen> createState() => _RideSelectionScreenState();
}

class _RideSelectionScreenState extends State<RideSelectionScreen> {
  late RideSelectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Create ViewModel with access to RideRepository
    _viewModel = RideSelectionViewModel(
      rideRepository: context.read<RideRepository>(),
    );

    // Initialize with search parameters
    _viewModel.initialize(
      departureLocation: widget.departureLocation,
      arrivalLocation: widget.arrivalLocation,
      departureDate: widget.departureDate,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Ride'), centerTitle: true),
      body: ChangeNotifierProvider<RideSelectionViewModel>.value(
        value: _viewModel,
        child: Consumer<RideSelectionViewModel>(
          builder: (context, viewModel, _) {
            return RideSelectionContent(
              viewModel: viewModel,
              onBackPressed: () => Navigator.pop(context),
              onRideSelected: (ride) {
                // TODO: Handle ride selection and navigate to booking screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${ride.driverName}')),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
