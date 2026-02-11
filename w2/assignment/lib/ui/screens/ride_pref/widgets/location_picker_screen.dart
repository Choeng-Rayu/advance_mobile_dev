import 'package:flutter/material.dart';
import 'package:blabla/ui/theme/theme.dart';
import '../../../../data/dummy_data.dart';
import '../../../../model/ride/locations.dart';
///
/// Location Picker Screen
/// Allows users to search and select a location with live filtering
///
class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Location> _filteredLocations;
  
  @override
  void initState() {
    super.initState();
    // Initialize with all locations from dummy data
    _filteredLocations = List.from(fakeLocations);
    
    // Listen to search input changes for live filtering
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Live search filter - filters by city name or country
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        _filteredLocations = List.from(fakeLocations);
      } else {
        _filteredLocations = fakeLocations.where((location) {
          final cityName = location.name.toLowerCase();
          final countryName = location.country.name.toLowerCase();
          return cityName.contains(query) || countryName.contains(query);
        }).toList();
      }
    });
  }

  /// Called when a location is selected
  void _onLocationSelected(Location location) {
    Navigator.of(context).pop(location);
  }

  /// Clear the search field
  void _onClearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: BlaColors.neutralDark,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search location...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: BlaColors.neutralLight),
          ),
          style: BlaTextStyles.body,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              color: BlaColors.neutralDark,
              onPressed: _onClearSearch,
            ),
        ],
      ),
      body: _filteredLocations.isEmpty
          ? Center(
              child: Text(
                'No locations found',
                style: BlaTextStyles.body.copyWith(
                  color: BlaColors.neutralLighter,
                ),
              ),
            )
          : ListView.builder(
              itemCount: _filteredLocations.length,
              itemBuilder: (context, index) {
                final location = _filteredLocations[index];
                return _buildLocationTile(location);
              },
            ),
    );
  }

  /// Build a single location tile
  Widget _buildLocationTile(Location location) {
    return ListTile(
      leading: Icon(
        Icons.location_on_outlined,
        color: BlaColors.neutralLight,
      ),
      title: Text(
        location.name,
        style: BlaTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        location.country.name,
        style: BlaTextStyles.label.copyWith(
          color: BlaColors.neutralLight,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: BlaColors.neutralLighter,
      ),
      onTap: () => _onLocationSelected(location),
    );
  }
}

