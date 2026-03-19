import 'package:flutter/foundation.dart';
import '../../../model/ride_preference.dart';
import '../../states/ride_perference_state.dart';

/// ViewModel for Home Screen
/// Delegates to RidePreferenceState for ride preference management
class HomeViewModel extends ChangeNotifier {
  final RidePreferenceState _ridePreferenceState;

  HomeViewModel({required RidePreferenceState ridePreferenceState})
    : _ridePreferenceState = ridePreferenceState {
    // Listen to ride preference state changes
    _ridePreferenceState.addListener(_onPreferenceStateChanged);
  }

  // Getters delegating to ride preference state
  RidePreference? get currentPreference =>
      _ridePreferenceState.currentPreference;
  List<RidePreference> get preferenceHistory =>
      _ridePreferenceState.preferenceHistory;

  /// Get preference history in reverse order (most recent first)
  List<RidePreference> getReversedHistory() {
    return _ridePreferenceState.getReversedHistory();
  }

  /// Select a ride preference
  Future<void> selectPreference(RidePreference preference) async {
    await _ridePreferenceState.selectPreference(preference);
  }

  /// Called when ride preference state changes
  void _onPreferenceStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _ridePreferenceState.removeListener(_onPreferenceStateChanged);
    super.dispose();
  }
}
