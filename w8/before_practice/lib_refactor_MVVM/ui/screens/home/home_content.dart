import 'package:flutter/material.dart';
import 'home_view_model.dart';

/// Stateless widget for Home Screen content
/// Receives HomeViewModel and renders UI based on preference history
class HomeContent extends StatelessWidget {
  final HomeViewModel viewModel;
  final VoidCallback onAddNewPreference;

  const HomeContent({
    super.key,
    required this.viewModel,
    required this.onAddNewPreference,
  });

  @override
  Widget build(BuildContext context) {
    final history = viewModel.getReversedHistory();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.blue.shade100,
            child: const Column(
              children: [
                Text(
                  'BlaBlaCar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Find your next ride'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Add New Preference Button
          ElevatedButton(
            onPressed: onAddNewPreference,
            child: const Text('+ New Search'),
          ),
          const SizedBox(height: 20),

          // Recent Searches
          if (history.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Searches',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  for (var pref in history) _buildHistoryTile(context, pref),
                ],
              ),
            ),
          ] else
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('No recent searches'),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryTile(BuildContext context, dynamic preference) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ID: ${preference.id}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text('Seats: ${preference.preferredSeats}'),
          Text('Max Price: \$${preference.maxPrice}'),
        ],
      ),
    );
  }
}
