import '../../../model/ride_preference.dart';

/// Fake ride preferences data for development and testing
final List<RidePreference> fakeRidePreferences = [
  RidePreference(
    id: 'pref_1',
    userId: 'user_1',
    preferredSeats: 1,
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
    preferredSeats: 2,
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
    preferredSeats: 1,
    acceptedCarTypes: ['Sedan', 'Hatchback', 'SUV', 'MPV'],
    maxPrice: 100.0,
    musicAllowed: false,
    petsAllowed: false,
    smokingAllowed: false,
    chattingPreference: true,
  ),
];
