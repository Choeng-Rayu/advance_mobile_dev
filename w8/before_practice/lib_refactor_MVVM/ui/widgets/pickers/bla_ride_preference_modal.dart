import 'package:flutter/material.dart';
import '../../../model/location.dart';
import '../../../model/ride_preference.dart';
import 'bla_location_picker.dart';
import 'bla_seat_picker.dart';

/// A modal that combines Location Picker, Ride Preference Picker, and Seat Picker
/// This serves as the main container for ride selection UI
///
/// Uses global ServiceLocator for repository access
/// Calls onRidePreferenceSelected callback when user searches for rides
class BlaRidePreferenceModal extends StatefulWidget {
  const BlaRidePreferenceModal({
    super.key,
    required this.onRidePreferenceSelected,
  });

  final Function(RidePreference) onRidePreferenceSelected;

  @override
  State<BlaRidePreferenceModal> createState() => _BlaRidePreferenceModalState();
}

class _BlaRidePreferenceModalState extends State<BlaRidePreferenceModal> {
  Location? departureLocation;
  Location? arrivalLocation;
  int selectedSeats = 1;
  DateTime? selectedDate;

  void _openLocationPicker(bool isDeparture) async {
    final result = await Navigator.of(context).push<Location>(
      MaterialPageRoute(
        builder: (context) => const BlaLocationPicker(initLocation: null),
      ),
    );

    if (result != null) {
      setState(() {
        if (isDeparture) {
          departureLocation = result;
        } else {
          arrivalLocation = result;
        }
      });
    }
  }

  Future<void> _searchRides() async {
    if (departureLocation == null || arrivalLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both departure and arrival locations'),
        ),
      );
      return;
    }

    // Create RidePreference with collected data
    // Using dummy ID and userId for now - these come from global state later
    final preference = RidePreference(
      id: 'pref_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current_user',
      departure: departureLocation!,
      arrival: arrivalLocation!,
      departureDate: selectedDate ?? DateTime.now(),
      requestedSeats: selectedSeats,
      maxPrice: 200,
      acceptedCarTypes: const [],
      musicAllowed: false,
      petsAllowed: false,
      smokingAllowed: false,
      chattingPreference: false,
    );

    // Call callback with selected preference
    widget.onRidePreferenceSelected(preference);

    // Close the modal
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void _resetForm() {
    setState(() {
      departureLocation = null;
      arrivalLocation = null;
      selectedSeats = 1;
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Ride'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Departure Location Section
            _buildSectionTitle('Departure Location'),
            _buildLocationCard(
              location: departureLocation,
              placeholder: 'Select departure location',
              onTap: () => _openLocationPicker(true),
            ),
            const SizedBox(height: 20),

            // Arrival Location Section
            _buildSectionTitle('Arrival Location'),
            _buildLocationCard(
              location: arrivalLocation,
              placeholder: 'Select arrival location',
              onTap: () => _openLocationPicker(false),
            ),
            const SizedBox(height: 20),

            // Seats Section
            _buildSectionTitle('Number of Seats'),
            BlaSeatsPicker(
              selectedSeats: selectedSeats,
              onSeatsChanged: (seats) {
                setState(() => selectedSeats = seats);
              },
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 32),

            // Search and Reset Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _searchRides,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Search Rides'),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLocationCard({
    required Location? location,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: location != null ? Colors.blue : Colors.grey[300]!,
            width: location != null ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: location != null ? Colors.blue.withValues(alpha: 0.05) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location?.name ?? placeholder,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: location != null ? Colors.black : Colors.grey,
                    ),
                  ),
                  if (location != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        location.address,
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              location != null ? Icons.check_circle : Icons.location_on,
              color: location != null ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
