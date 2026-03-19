import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/location/location_repository_mock.dart';
import 'data/repositories/ride/ride_repository_mock.dart';
import 'data/repositories/ride_preference/ride_preference_repository_mock.dart';
import 'data/repositories/location/locations_repository.dart';
import 'data/repositories/ride/rides_repository.dart';
import 'data/repositories/ride_preference/ride_preference_repository.dart';
import 'ui/states/ride_perference_state.dart';

void main() {
  runApp(const BlaBlaApp());
}

class BlaBlaApp extends StatelessWidget {
  const BlaBlaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocationRepository>(create: (_) => LocationRepositoryMock()),
        Provider<RideRepository>(create: (_) => RideRepositoryMock()),
        Provider<RidePreferenceRepository>(
          create: (_) => RidePreferenceRepositoryMock(),
        ),
        ChangeNotifierProvider<RidePreferenceState>(
          create: (context) => RidePreferenceState(
            repository: context.read<RidePreferenceRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
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
                  onPressed: () => _testRepositories(context),
                  child: const Text('Test Repositories'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _testRepositories(BuildContext context) async {
    // Get repositories synchronously before async operations
    final locationRepository = context.read<LocationRepository>();
    final rideRepository = context.read<RideRepository>();
    final ridePreferenceRepository = context.read<RidePreferenceRepository>();

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
