import 'package:blabla/model/ride/ride.dart';

import 'package:blabla/model/ride/locations.dart';
import 'package:blabla/services/rides_service.dart';
// import '../lib/services/location_service.dart';
// import 'package:blabla/services/location_service.dart';

void main() {
  // Location dijon = Location(country: Country.france, name: "Dijon");

  List<Ride> filteredRide = RidesService.filterBy(
      departure: Location(name: "Dijon", country: Country.france),
      seatsRequested: 2
  );

  for (Ride ride in filteredRide) {
    print(ride);
  }
 
}
