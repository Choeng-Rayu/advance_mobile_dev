import 'location.dart';

///
/// This model describes a ride preference.
/// A ride preference consists of the selection of a departure + arrival + a date and a number of passenger
/// Additional preferences include filters for car types, amenities, and pricing
///
class RidePreference {
  final String id;
  final String userId;
  final Location departure;
  final DateTime departureDate;
  final Location arrival;
  final int requestedSeats;
  final List<String> acceptedCarTypes;
  final double maxPrice;
  final bool musicAllowed;
  final bool petsAllowed;
  final bool smokingAllowed;
  final bool chattingPreference;

  RidePreference({
    required this.id,
    required this.userId,
    required this.departure,
    required this.departureDate,
    required this.arrival,
    required this.requestedSeats,
    this.acceptedCarTypes = const [],
    this.maxPrice = 200,
    this.musicAllowed = false,
    this.petsAllowed = false,
    this.smokingAllowed = false,
    this.chattingPreference = false,
  });

  @override
  String toString() =>
      'RidePreference(departure: ${departure.name}, arrival: ${arrival.name}, '
      'departureDate: ${departureDate.toIso8601String()}, requestedSeats: $requestedSeats)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RidePreference &&
        other.id == id &&
        other.userId == userId &&
        other.departure == departure &&
        other.departureDate == departureDate &&
        other.arrival == arrival &&
        other.requestedSeats == requestedSeats;
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    departure,
    departureDate,
    arrival,
    requestedSeats,
  );
}
