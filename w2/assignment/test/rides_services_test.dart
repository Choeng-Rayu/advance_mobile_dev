import 'package:blabla/model/ride/ride.dart';
import 'package:blabla/data/dummy_data.dart';

import 'package:blabla/model/ride/locations.dart';
import 'package:blabla/services/rides_service.dart';

void main() {
  RidesService.allRides;
  print(RidesService.allRides);
}

class RidesService {
  static List<Ride> allRides = fakeRides;

  // TODO Create a static method to filter rides by departure location
  static List<Ride> filterByDeparture(Location departure) {
    return allRides
        .where((ride) => ride.departureLocation == (departure))
        .toList();
  }

  // TODO Create a static method to filter rides by number of requested seat
  static List<Ride> filterBySeatRequested(int seatRequested) {
    return allRides
        .where((ride) => ride.remainingSeats >= seatRequested)
        .toList();
  }

  // TODO Create a static method to filter : optional departure location, optional requested seat
  static List<Ride> filterBy({Location? departure, int? seatRequested}) {
    return allRides.where((ride) {
      if (departure != null && ride.departureLocation != departure) {
        return false;
      }

      if (seatRequested != null && ride.remainingSeats < seatRequested) {
        return false;
      }

      return true;
    }).toList();
  }
}
