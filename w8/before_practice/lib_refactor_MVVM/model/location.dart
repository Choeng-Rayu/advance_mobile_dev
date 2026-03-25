class Location {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Location({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() =>
      'Location(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude)';
}
