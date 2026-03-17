import '../../../model/ride_preference.dart';
import 'ride_preference_repository.dart';
import 'fake_ride_preferences.dart';

/// Mock implementation of RidePreferenceRepository for development and testing
class RidePreferenceRepositoryMock implements RidePreferenceRepository {
  /// In-memory storage for preferences (simulates database)
  final Map<String, RidePreference> _preferences = {};

  RidePreferenceRepositoryMock() {
    // Initialize with fake data
    for (final pref in fakeRidePreferences) {
      _preferences[pref.userId] = pref;
    }
  }

  @override
  Future<RidePreference?> getUserPreferences(String userId) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300));
    return _preferences[userId];
  }

  @override
  Future<RidePreference> saveUserPreferences(RidePreference preference) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 400));
    _preferences[preference.userId] = preference;
    return preference;
  }

  @override
  Future<bool> deleteUserPreferences(String userId) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300));
    return _preferences.remove(userId) != null;
  }

  @override
  Future<List<RidePreference>> getAllPreferences() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));
    return _preferences.values.toList();
  }
}
