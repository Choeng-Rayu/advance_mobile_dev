import '../../../model/ride.dart';
import 'rides_repository.dart';
import 'fake_rides.dart';

/// Mock implementation of RideRepository for development and testing
class RideRepositoryMock implements RideRepository {
  @override
  Future<List<Ride>> getAllRides() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));
    return fakeRides;
  }

  @override
  Future<Ride?> getRideById(String id) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300));
    try {
      return fakeRides.firstWhere((ride) => ride.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Ride>> searchRides({
    required String departureLocation,
    required String arrivalLocation,
    required DateTime departureDate,
    int? maxPrice,
    int? availableSeats,
  }) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 400));

    return fakeRides.where((ride) {
      final matchesDeparture = ride.departureLocation.toLowerCase().contains(
        departureLocation.toLowerCase(),
      );
      final matchesArrival = ride.arrivalLocation.toLowerCase().contains(
        arrivalLocation.toLowerCase(),
      );
      final matchesDate =
          ride.departureTime.day == departureDate.day &&
          ride.departureTime.month == departureDate.month &&
          ride.departureTime.year == departureDate.year;
      final matchesPrice = maxPrice == null || ride.price <= maxPrice;
      final matchesSeats =
          availableSeats == null || ride.availableSeats >= availableSeats;

      return matchesDeparture &&
          matchesArrival &&
          matchesDate &&
          matchesPrice &&
          matchesSeats;
    }).toList();
  }

  @override
  Future<List<Ride>> getRidesByDriver(String driverId) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300));
    return fakeRides.where((ride) => ride.id.contains(driverId)).toList();
  }

  @override
  Future<bool> bookRide(String rideId, String userId, int seats) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));
    try {
      final ride = fakeRides.firstWhere((r) => r.id == rideId);
      // Check if enough seats are available
      if (ride.availableSeats >= seats) {
        // In a real implementation, this would update the database
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> cancelRideBooking(String bookingId) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 400));
    // In a real implementation, this would update the database
    return true;
  }
}
