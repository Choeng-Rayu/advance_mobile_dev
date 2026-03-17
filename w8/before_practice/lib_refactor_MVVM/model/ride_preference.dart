class RidePreference {
  final String id;
  final String userId;
  final int preferredSeats;
  final List<String> acceptedCarTypes;
  final double maxPrice;
  final bool musicAllowed;
  final bool petsAllowed;
  final bool smokingAllowed;
  final bool chattingPreference;

  RidePreference({
    required this.id,
    required this.userId,
    required this.preferredSeats,
    required this.acceptedCarTypes,
    required this.maxPrice,
    required this.musicAllowed,
    required this.petsAllowed,
    required this.smokingAllowed,
    required this.chattingPreference,
  });

  @override
  String toString() =>
      'RidePreference(id: $id, userId: $userId, preferredSeats: $preferredSeats)';
}
