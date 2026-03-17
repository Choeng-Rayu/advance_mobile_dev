import 'package:flutter/material.dart';
import 'data/repositories/location/location_repository_mock.dart';
import 'data/repositories/ride/ride_repository_mock.dart';
import 'data/repositories/ride_preference/ride_preference_repository_mock.dart';
import 'data/repositories/location/locations_repository.dart';
import 'data/repositories/ride/rides_repository.dart';
import 'data/repositories/ride_preference/ride_preference_repository.dart';

void main() {
  runApp(const BlaBlaApp());
}

class BlaBlaApp extends StatelessWidget {
  const BlaBlaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize repositories for dependency injection
    final LocationRepository locationRepository = LocationRepositoryMock();
    final RideRepository rideRepository = RideRepositoryMock();
    final RidePreferenceRepository ridePreferenceRepository =
        RidePreferenceRepositoryMock();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('BlaBlaCar MVVM')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Repositories Initialized Successfully!'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _testRepositories(
                  locationRepository,
                  rideRepository,
                  ridePreferenceRepository,
                ),
                child: const Text('Test Repositories'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _testRepositories(
    LocationRepository locationRepository,
    RideRepository rideRepository,
    RidePreferenceRepository ridePreferenceRepository,
  ) async {
    // Test LocationRepository
    final locations = await locationRepository.getAllLocations();
    debugPrint('Locations fetched: ${locations.length}');

    // Test RideRepository
    final rides = await rideRepository.getAllRides();
    debugPrint('Rides fetched: ${rides.length}');

    // Test RidePreferenceRepository
    final preferences = await ridePreferenceRepository.getAllPreferences();
    debugPrint('Preferences fetched: ${preferences.length}');
  }
}
