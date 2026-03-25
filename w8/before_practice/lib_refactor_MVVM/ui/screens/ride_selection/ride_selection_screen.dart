import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../model/ride.dart';
import 'ride_selection_content.dart';
import 'ride_selection_view_model.dart';

/// Ride Selection Screen - Main screen for displaying available rides
/// Listens to global RidePreferenceState to get current preferences
///
/// Architecture:
/// - RideSelectionScreen (Stateful, listens to global state)
///   └─ RideSelectionViewModel (manages ride fetching and filtering)
///       └─ RideSelectionContent (Stateless, receives ViewModel)
class RideSelectionScreen extends StatefulWidget {
  const RideSelectionScreen({super.key});

  @override
  State<RideSelectionScreen> createState() => _RideSelectionScreenState();
}

class _RideSelectionScreenState extends State<RideSelectionScreen> {
  late RideSelectionViewModel _viewModel;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeViewModel();
  }

  /// Initialize the ViewModel with current preference from global state
  Future<void> _initializeViewModel() async {
    _viewModel = RideSelectionViewModel();

    // Get current preference from global state
    final currentPreference =
        ServiceLocator.ridePreferenceState.currentPreference;
    if (currentPreference != null) {
      // Initialize rides with this preference
      await _viewModel.initialize(currentPreference);
    }

    setState(() {
      _initialized = true;
    });
  }

  /// Handle ride selection
  void _onRideSelected(Ride ride) {
    // TODO: Navigate to ride details or booking screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected ride by ${ride.driverName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return RideSelectionContent(
      viewModel: _viewModel,
      onRideSelected: _onRideSelected,
    );
  }
}
