import '../data/dummy_data.dart';
import '../model/ride/ride.dart';
import '../model/ride/locations.dart';

////
///   This service handles:
///   - The list of available rides
// ///
// class RidesService {
//   static List<Ride> allRides = fakeRides;

//   static List<Ride> filterBy({
//     required Location departure,
//     required int seatsRequested,
//   }) {
//     return allRides.where((ride) {
//       return ride.departureLocation == departure &&
//           ride.availableSeats >= seatsRequested;
//     }).toList();
//   }
// }

class RidesService {
  static List<Ride> totalRides = fakeRides;

  // TODO Create a static method to filter rides by departure location
  static List<Ride> filterByDeparture(Location departure) {
    return totalRides
        .where((ride) => ride.departureLocation == (departure))
        .toList();
  }

  // TODO Create a static method to filter rides by number of requested seat
  static List<Ride> filterBySeatRequested(int seatRequested) {
    return totalRides
        .where((ride) => ride.remainingSeats >= seatRequested)
        .toList();
  }

  // TODO Create a static method to filter : optional departure location, optional requested seat
  static List<Ride> filterBy({Location? departure, int? seatsRequested}) {
    return totalRides.where((ride) {
      if (departure != null && ride.departureLocation != departure) {
        return false;
      }

      if (seatsRequested != null && ride.remainingSeats < seatsRequested) {
        return false;
      }

      return true;
    }).toList();
  }
}
