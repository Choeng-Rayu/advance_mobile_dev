import 'package:flutter/foundation.dart';
import '../../../main.dart';
import '../../../model/ride_preference.dart';

/// ViewModel for the Home Screen
/// Delegates to the global RidePreferenceState for preference management
class HomeViewModel extends ChangeNotifier {
  /// Get current selected preference from global state
  RidePreference? get selectedPreference =>
      ServiceLocator.ridePreferenceState.currentPreference;

  /// Get preference history from global state
  List<RidePreference> get preferenceHistory =>
      ServiceLocator.ridePreferenceState.preferenceHistory;

  /// Check if global state is loading
  bool get isLoading => ServiceLocator.ridePreferenceState.isLoading;

  /// Select a ride preference using global state
  Future<void> selectPreference(RidePreference preference) async {
    await ServiceLocator.ridePreferenceState.selectPreference(preference);
  }

  /// Get preferences history in reverse order (most recent first)
  List<RidePreference> getReversedHistory() {
    return ServiceLocator.ridePreferenceState.getReversedHistory();
  }
}
