class Ride {
  final String id;
  final String driverName;
  final double price;
  final int availableSeats;
  final String departureLocation;
  final String arrivalLocation;
  final DateTime departureTime;
  final int estimatedDuration; // in minutes
  final String carType;
  final double rating;
  final int rideCount;

  Ride({
    required this.id,
    required this.driverName,
    required this.price,
    required this.availableSeats,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.departureTime,
    required this.estimatedDuration,
    required this.carType,
    required this.rating,
    required this.rideCount,
  });

  @override
  String toString() =>
      'Ride(id: $id, driverName: $driverName, price: $price, availableSeats: $availableSeats)';
}
