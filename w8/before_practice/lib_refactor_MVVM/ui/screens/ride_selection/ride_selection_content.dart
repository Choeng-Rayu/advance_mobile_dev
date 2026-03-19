import 'package:flutter/material.dart';
import '../../../model/ride.dart';
import 'ride_selection_view_model.dart';

/// Stateless widget for Ride Selection Screen content
/// Displays filtered list of rides
class RideSelectionContent extends StatelessWidget {
  final RideSelectionViewModel viewModel;
  final VoidCallback onBackPressed;
  final Function(Ride) onRideSelected;

  const RideSelectionContent({
    super.key,
    required this.viewModel,
    required this.onBackPressed,
    required this.onRideSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with back button and filters
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed,
              ),
              const Text(
                'Available Rides',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterDialog(context),
              ),
            ],
          ),
        ),

        // Error message if any
        if (viewModel.error != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red.shade100,
            child: Text(
              viewModel.error!,
              style: TextStyle(color: Colors.red.shade800),
            ),
          ),
        ],

        // Loading indicator
        if (viewModel.isLoading) ...[
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ] else if (viewModel.filteredRides.isEmpty) ...[
          // Empty state
          const Expanded(child: Center(child: Text('No rides available'))),
        ] else ...[
          // Rides list
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.filteredRides.length,
              itemBuilder: (context, index) {
                final ride = viewModel.filteredRides[index];
                return _buildRideTile(context, ride);
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRideTile(BuildContext context, Ride ride) {
    return GestureDetector(
      onTap: () => onRideSelected(ride),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver name and rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ride.driverName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${ride.rating}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Route info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ride.departureLocation),
                    const SizedBox(height: 4),
                    Text(
                      ride.departureTime.toString().split('.')[0],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(ride.arrivalLocation),
                    const SizedBox(height: 4),
                    Text(
                      '${ride.estimatedDuration} min',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Price and seats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${ride.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                Text('${ride.availableSeats} seats available'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Rides'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filter options coming soon'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                viewModel.resetFilters();
                Navigator.pop(context);
              },
              child: const Text('Reset Filters'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
