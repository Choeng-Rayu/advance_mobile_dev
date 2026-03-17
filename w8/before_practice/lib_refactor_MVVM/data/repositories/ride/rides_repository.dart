import '../../../model/ride.dart';

/// Abstract repository for Ride data operations
/// Handles all ride-related data access logic
abstract class RideRepository {
  /// Fetch all available rides
  Future<List<Ride>> getAllRides();

  /// Fetch a specific ride by ID
  Future<Ride?> getRideById(String id);

  /// Search rides by departure and arrival locations
  Future<List<Ride>> searchRides({
    required String departureLocation,
    required String arrivalLocation,
    required DateTime departureDate,
    int? maxPrice,
    int? availableSeats,
  });

  /// Fetch rides by driver ID
  Future<List<Ride>> getRidesByDriver(String driverId);

  /// Book a ride
  Future<bool> bookRide(String rideId, String userId, int seats);

  /// Cancel a ride booking
  Future<bool> cancelRideBooking(String bookingId);
}
