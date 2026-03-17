import 'dart:math';

import '../../../model/location.dart';
import 'locations_repository.dart';
import 'fake_locations.dart';

/// Mock implementation of LocationRepository for development and testing
class LocationRepositoryMock implements LocationRepository {
  @override
  Future<List<Location>> getAllLocations() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));
    return fakeLocations;
  }

  @override
  Future<Location?> getLocationById(String id) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300));
    try {
      return fakeLocations.firstWhere((location) => location.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Location>> searchLocations(String query) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 400));
    final lowerQuery = query.toLowerCase();
    return fakeLocations
        .where(
          (location) =>
              location.name.toLowerCase().contains(lowerQuery) ||
              location.address.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  @override
  Future<List<Location>> getNearbyLocations(
    double latitude,
    double longitude,
    double radiusKm,
  ) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 400));

    // Simple distance calculation (Haversine formula simplified)
    return fakeLocations.where((location) {
      final distance = _calculateDistance(
        latitude,
        longitude,
        location.latitude,
        location.longitude,
      );
      return distance <= radiusKm;
    }).toList();
  }

  /// Calculate distance between two coordinates in kilometers
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
