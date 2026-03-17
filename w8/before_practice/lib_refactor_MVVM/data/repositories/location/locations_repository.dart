import '../../../model/location.dart';

/// Abstract repository for Location data operations
/// Handles all location-related data access logic
abstract class LocationRepository {
  /// Fetch all available locations
  Future<List<Location>> getAllLocations();

  /// Fetch a specific location by ID
  Future<Location?> getLocationById(String id);

  /// Search locations by name or address
  Future<List<Location>> searchLocations(String query);

  /// Get locations nearby based on coordinates
  Future<List<Location>> getNearbyLocations(
    double latitude,
    double longitude,
    double radiusKm,
  );
}
