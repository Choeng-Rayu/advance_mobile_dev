import 'package:flutter/material.dart';
import '../../../model/location.dart';
import '../../../main.dart';

/// A Location Picker widget that fetches locations from global LocationRepository
/// and allows users to search and select a location
class BlaLocationPicker extends StatefulWidget {
  const BlaLocationPicker({super.key, this.initLocation});

  final Location? initLocation;

  @override
  State<BlaLocationPicker> createState() => _BlaLocationPickerState();
}

class _BlaLocationPickerState extends State<BlaLocationPicker> {
  String currentSearchText = "";
  List<Location> allLocations = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLocations();

    // Initialize search text with initial location if provided
    if (widget.initLocation != null) {
      setState(() {
        currentSearchText = widget.initLocation!.name;
      });
    }
  }

  Future<void> _loadLocations() async {
    try {
      final locations = await ServiceLocator.locationRepository
          .getAllLocations();
      setState(() {
        allLocations = locations;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load locations';
        isLoading = false;
      });
    }
  }

  void onTap(Location location) {
    Navigator.pop<Location>(context, location);
  }

  void onBackTap() {
    Navigator.pop(context);
  }

  void onSearchChanged(String search) {
    setState(() {
      currentSearchText = search;
    });
  }

  /// Get filtered locations based on search text
  List<Location> get filteredLocations {
    if (currentSearchText.isEmpty) {
      return [];
    }
    return allLocations
        .where(
          (location) =>
              location.name.toLowerCase().contains(
                currentSearchText.toLowerCase(),
              ) ||
              location.address.toLowerCase().contains(
                currentSearchText.toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackTap,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar
                  LocationSearchBar(
                    initSearch: currentSearchText,
                    onBackTap: onBackTap,
                    onSearchChanged: onSearchChanged,
                  ),
                  const SizedBox(height: 16),
                  // Results List
                  Expanded(
                    child: filteredLocations.isEmpty
                        ? Center(
                            child: Text(
                              currentSearchText.isEmpty
                                  ? 'Start typing to search locations'
                                  : 'No locations found',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredLocations.length,
                            itemBuilder: (context, index) => LocationTile(
                              location: filteredLocations[index],
                              onTap: onTap,
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// Search bar widget for location picker
class LocationSearchBar extends StatefulWidget {
  const LocationSearchBar({
    super.key,
    required this.onBackTap,
    required this.onSearchChanged,
    required this.initSearch,
  });

  final String initSearch;
  final VoidCallback onBackTap;
  final ValueChanged<String> onSearchChanged;

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initSearch;
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void onClearTap() {
    _searchController.clear();
    widget.onSearchChanged('');
    setState(() {});
  }

  bool get searchIsNotEmpty => _searchController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          // BACK ICON
          IconButton(
            onPressed: widget.onBackTap,
            icon: const Icon(Icons.arrow_back_ios, size: 16),
          ),
          // TEXT FIELD
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              decoration: const InputDecoration(
                hintText: "Any city, street...",
                border: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          // CLEAR ICON
          searchIsNotEmpty
              ? IconButton(
                  onPressed: onClearTap,
                  icon: const Icon(Icons.close, size: 16),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

/// Individual location tile in the list
class LocationTile extends StatelessWidget {
  const LocationTile({super.key, required this.location, required this.onTap});

  final Location location;
  final ValueChanged<Location> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => onTap(location),
          leading: const Icon(Icons.location_on, size: 20),
          title: Text(
            location.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            location.address,
            style: Theme.of(context).textTheme.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
