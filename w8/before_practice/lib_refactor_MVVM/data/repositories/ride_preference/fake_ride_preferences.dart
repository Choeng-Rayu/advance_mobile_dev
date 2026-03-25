import '../../../model/ride_preference.dart';
import '../location/fake_locations.dart';

/// Fake ride preferences data for development and testing
final List<RidePreference> fakeRidePreferences = [
  RidePreference(
    id: 'pref_1',
    userId: 'user_1',
    departure: fakeLocations[0], // Paris - Eiffel Tower
    departureDate: DateTime.now().add(Duration(days: 1)),
    arrival: fakeLocations[3], // Lyon
    requestedSeats: 1,
    acceptedCarTypes: ['Sedan', 'Hatchback', 'SUV'],
    maxPrice: 50.0,
    musicAllowed: true,
    petsAllowed: false,
    smokingAllowed: false,
    chattingPreference: true,
  ),
  RidePreference(
    id: 'pref_2',
    userId: 'user_2',
    departure: fakeLocations[0], // Paris - Eiffel Tower
    departureDate: DateTime.now().add(Duration(days: 2)),
    arrival: fakeLocations[4], // Marseille
    requestedSeats: 2,
    acceptedCarTypes: ['Sedan', 'SUV'],
    maxPrice: 35.0,
    musicAllowed: true,
    petsAllowed: true,
    smokingAllowed: false,
    chattingPreference: false,
  ),
  RidePreference(
    id: 'pref_3',
    userId: 'user_3',
    departure: fakeLocations[3], // Lyon
    departureDate: DateTime.now().add(Duration(days: 3)),
    arrival: fakeLocations[5], // Toulouse
    requestedSeats: 1,
    acceptedCarTypes: ['Sedan', 'Hatchback', 'SUV', 'MPV'],
    maxPrice: 100.0,
    musicAllowed: false,
    petsAllowed: false,
    smokingAllowed: false,
    chattingPreference: true,
  ),
];
