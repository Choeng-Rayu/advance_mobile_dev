import 'package:flutter/material.dart';
import 'data/repositories/location/location_repository_mock.dart';
import 'data/repositories/ride/ride_repository_mock.dart';
import 'data/repositories/ride_preference/ride_preference_repository_mock.dart';
import 'data/repositories/location/locations_repository.dart';
import 'data/repositories/ride/rides_repository.dart';
import 'data/repositories/ride_preference/ride_preference_repository.dart';
import 'ui/theme/theme.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/states/ride_perference_state.dart';

/// Global service locator for repositories and states
class ServiceLocator {
  static late LocationRepository _locationRepository;
  static late RideRepository _rideRepository;
  static late RidePreferenceRepository _ridePreferenceRepository;
  static late RidePreferenceState _ridePreferenceState;

  /// Initialize repositories and global states
  static void setup() {
    _locationRepository = LocationRepositoryMock();
    _rideRepository = RideRepositoryMock();
    _ridePreferenceRepository = RidePreferenceRepositoryMock();
    _ridePreferenceState = RidePreferenceState();
  }

  // Getters for global access to repositories
  static LocationRepository get locationRepository => _locationRepository;
  static RideRepository get rideRepository => _rideRepository;
  static RidePreferenceRepository get ridePreferenceRepository =>
      _ridePreferenceRepository;

  // Getter for global state
  static RidePreferenceState get ridePreferenceState => _ridePreferenceState;
}

void main() {
  // Initialize all repositories globally
  ServiceLocator.setup();
  runApp(const BlaBlaApp());
}

class BlaBlaApp extends StatefulWidget {
  const BlaBlaApp({super.key});

  @override
  State<BlaBlaApp> createState() => _BlaBlaAppState();
}

class _BlaBlaAppState extends State<BlaBlaApp> {
  @override
  void initState() {
    super.initState();
    // Initialize the global RidePreferenceState
    ServiceLocator.ridePreferenceState.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlaBlaCar MVVM',
      theme: blaTheme,
      home: const HomeScreen(),
    );
  }
}
