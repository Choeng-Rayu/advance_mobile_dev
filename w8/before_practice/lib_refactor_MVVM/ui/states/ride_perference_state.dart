import 'package:flutter/foundation.dart';
import '../../main.dart';
import '../../model/ride_preference.dart';

/// Global state for managing ride preferences
/// Handles:
/// - Current selected ride preference
/// - History of past preferences
/// - State notifications to listeners
class RidePreferenceState extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _preferenceHistory = [];
  bool _isLoading = false;

  // Getters
  RidePreference? get currentPreference => _currentPreference;
  List<RidePreference> get preferenceHistory => _preferenceHistory;
  bool get isLoading => _isLoading;

  /// Initialize the state by loading preferences from repository
  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load all preferences (history)
      _preferenceHistory = await ServiceLocator.ridePreferenceRepository
          .getAllPreferences();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Select a ride preference
  /// - Updates current preference if different
  /// - Adds to history if new
  /// - Notifies all listeners
  Future<void> selectPreference(RidePreference newPreference) async {
    // Check if preference is different from current one
    if (_currentPreference != newPreference) {
      _currentPreference = newPreference;

      // Add to history if not already there
      if (!_preferenceHistory.contains(newPreference)) {
        _preferenceHistory.insert(0, newPreference);

        // Save to repository
        try {
          await ServiceLocator.ridePreferenceRepository.saveUserPreferences(
            newPreference,
          );
        } catch (e) {
          // Handle error but still update UI
        }
      }

      // Notify all listeners of the state change
      notifyListeners();
    }
  }

  /// Get preference history in reverse order (most recent first)
  List<RidePreference> getReversedHistory() {
    return _preferenceHistory.reversed.toList();
  }
}
