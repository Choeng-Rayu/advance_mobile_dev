import 'package:flutter/foundation.dart';
import '../../../model/ride.dart';
import '../../../data/repositories/ride/rides_repository.dart';

/// ViewModel for Ride Selection Screen
/// Manages fetching and filtering rides
class RideSelectionViewModel extends ChangeNotifier {
  final RideRepository _rideRepository;

  List<Ride> _allRides = [];
  List<Ride> _filteredRides = [];
  bool _isLoading = false;
  String? _error;

  // Filter values
  double? _maxPrice;
  double? _minRating;

  RideSelectionViewModel({required RideRepository rideRepository})
    : _rideRepository = rideRepository;

  // Getters
  List<Ride> get filteredRides => List.unmodifiable(_filteredRides);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize and fetch rides
  Future<void> initialize({
    required String departureLocation,
    required String arrivalLocation,
    required DateTime departureDate,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      _allRides = await _rideRepository.searchRides(
        departureLocation: departureLocation,
        arrivalLocation: arrivalLocation,
        departureDate: departureDate,
      );
      _filteredRides = List.from(_allRides);
      _error = null;
    } catch (e) {
      _error = 'Failed to load rides: $e';
      debugPrint('Error initializing rides: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Filter rides by price
  void filterByPrice(double maxPrice) {
    _maxPrice = maxPrice;
    _applyFilters();
  }

  /// Filter rides by rating
  void filterByRating(double minRating) {
    _minRating = minRating;
    _applyFilters();
  }

  /// Reset all filters
  void resetFilters() {
    _maxPrice = null;
    _minRating = null;
    _filteredRides = List.from(_allRides);
    notifyListeners();
  }

  /// Private helper to apply all active filters
  void _applyFilters() {
    _filteredRides = _allRides.where((ride) {
      if (_maxPrice != null && ride.price > _maxPrice!) {
        return false;
      }
      if (_minRating != null && ride.rating < _minRating!) {
        return false;
      }
      return true;
    }).toList();
    notifyListeners();
  }

  /// Private helper to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Select a ride (for booking)
  Future<bool> bookRide(String rideId, String userId, int seats) async {
    try {
      return await _rideRepository.bookRide(rideId, userId, seats);
    } catch (e) {
      _error = 'Failed to book ride: $e';
      debugPrint('Error booking ride: $e');
      notifyListeners();
      return false;
    }
  }
}
