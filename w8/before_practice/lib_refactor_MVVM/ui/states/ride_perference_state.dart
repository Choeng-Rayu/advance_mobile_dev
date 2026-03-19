import 'package:flutter/foundation.dart';
import '../../data/repositories/ride_preference/ride_preference_repository.dart';
import '../../model/ride_preference.dart';

/// Global state management for ride preferences using Provider pattern
/// Manages the currently selected ride preference and preference history
class RidePreferenceState extends ChangeNotifier {
  final RidePreferenceRepository _repository;

  RidePreference? _currentPreference;
  final List<RidePreference> _preferenceHistory = [];

  RidePreferenceState({required RidePreferenceRepository repository})
    : _repository = repository;

  // Getters
  RidePreference? get currentPreference => _currentPreference;
  List<RidePreference> get preferenceHistory =>
      List.unmodifiable(_preferenceHistory);

  /// Initialize state by loading preferences from storage
  Future<void> initialize(String userId) async {
    _currentPreference = await _repository.getUserPreferences(userId);
    notifyListeners();
  }

  /// Select a ride preference, update current preference, and save to repository
  Future<void> selectPreference(RidePreference preference) async {
    try {
      // Save to repository
      _currentPreference = await _repository.saveUserPreferences(preference);

      // Add to history if not already there
      if (_preferenceHistory.isEmpty ||
          _preferenceHistory.last.id != preference.id) {
        _preferenceHistory.add(preference);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error selecting preference: $e');
      rethrow;
    }
  }

  /// Get preference history in reverse order (most recent first)
  List<RidePreference> getReversedHistory() {
    return List.from(_preferenceHistory.reversed);
  }

  /// Clear current preference
  Future<void> clearPreference(String userId) async {
    try {
      await _repository.deleteUserPreferences(userId);
      _currentPreference = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing preference: $e');
      rethrow;
    }
  }
}
