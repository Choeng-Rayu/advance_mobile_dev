import 'package:flutter/foundation.dart';
import '../../../main.dart';
import '../../../model/ride.dart';
import '../../../model/ride_preference.dart';

/// ViewModel for the Ride Selection Screen
/// Manages ride search, filtering, and preference updates
/// Uses global ServiceLocator for repository access
class RideSelectionViewModel extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<Ride> _allRides = [];
  List<Ride> _filteredRides = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  RidePreference? get currentPreference => _currentPreference;
  List<Ride> get filteredRides => _filteredRides;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get ridesCount => _filteredRides.length;

  /// Initialize with a ride preference and fetch matching rides
  Future<void> initialize(RidePreference preference) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _currentPreference = preference;
      notifyListeners();

      // Fetch all rides using global repository
      _allRides = await ServiceLocator.rideRepository.getAllRides();

      // Filter rides based on preference
      _filterRides();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load rides: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update the current preference and re-filter rides
  Future<void> updatePreference(RidePreference newPreference) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _currentPreference = newPreference;
      notifyListeners();

      // Save the updated preference using global repository
      await ServiceLocator.ridePreferenceRepository.saveUserPreferences(
        newPreference,
      );

      // Re-filter rides with new preference
      _filterRides();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update preference: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filter rides based on current preference
  void _filterRides() {
    if (_currentPreference == null) {
      _filteredRides = [];
      return;
    }

    _filteredRides = _allRides
        .where(
          (ride) =>
              ride.departureLocation == _currentPreference!.departure.name &&
              ride.arrivalLocation == _currentPreference!.arrival.name &&
              ride.availableSeats >= _currentPreference!.requestedSeats,
        )
        .toList();
  }

  /// Filter rides by price range
  void filterByPrice(double minPrice, double maxPrice) {
    _filteredRides = _allRides
        .where(
          (ride) =>
              ride.departureLocation == _currentPreference!.departure.name &&
              ride.arrivalLocation == _currentPreference!.arrival.name &&
              ride.availableSeats >= _currentPreference!.requestedSeats &&
              ride.price >= minPrice &&
              ride.price <= maxPrice,
        )
        .toList();
    notifyListeners();
  }

  /// Filter rides by rating
  void filterByRating(double minRating) {
    _filteredRides = _allRides
        .where(
          (ride) =>
              ride.departureLocation == _currentPreference!.departure.name &&
              ride.arrivalLocation == _currentPreference!.arrival.name &&
              ride.availableSeats >= _currentPreference!.requestedSeats &&
              ride.rating >= minRating,
        )
        .toList();
    notifyListeners();
  }

  /// Reset filters (show all matching rides)
  void resetFilters() {
    _filterRides();
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
