import '../../../model/ride_preference.dart';

/// Abstract repository for Ride Preference data operations
/// Handles all ride preference-related data access logic
abstract class RidePreferenceRepository {
  /// Fetch ride preferences for a specific user
  Future<RidePreference?> getUserPreferences(String userId);

  /// Create or update user ride preferences
  Future<RidePreference> saveUserPreferences(RidePreference preference);

  /// Delete user ride preferences
  Future<bool> deleteUserPreferences(String userId);

  /// Fetch all preferences (admin use case)
  Future<List<RidePreference>> getAllPreferences();
}
