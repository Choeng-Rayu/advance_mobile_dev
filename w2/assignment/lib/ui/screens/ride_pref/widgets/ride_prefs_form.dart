import 'package:flutter/material.dart';
import 'package:blabla/ui/theme/theme.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../widgets/actions/blaButton.dart';
import '../../../../model/ride/locations.dart';
import '../../../../model/ride_pref/ride_pref.dart';
import '../widgets/location_picker_screen.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
class RidePrefForm extends StatefulWidget {
  // The form can be created with an optional initial RidePref.
  final RidePref? initRidePref;

  const RidePrefForm({super.key, this.initRidePref});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  late DateTime departureDate;
  Location? arrival;
  late int requestedSeats;

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------

  void _initFormAttributes() {
    if (widget.initRidePref != null) {
      departure = widget.initRidePref!.departure;
      arrival = widget.initRidePref!.arrival;
      departureDate = widget.initRidePref!.departureDate;
      requestedSeats = widget.initRidePref!.requestedSeats;
    } else {
      departure = null;
      arrival = null;
      departureDate = DateTime.now();
      requestedSeats = 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _initFormAttributes();
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------
  void _onDeparturePressed() async {
    final Location? result = await Navigator.of(context).push<Location>(
      MaterialPageRoute(
        builder: (context) => const LocationPickerScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        departure = result;
      });
    }
  }

  void _onArrivalPressed() async {
    final Location? result = await Navigator.of(context).push<Location>(
      MaterialPageRoute(
        builder: (context) => const LocationPickerScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        arrival = result;
      });
    }
  }

  void _onDatePressed() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime.now(), // Cannot select past dates
      lastDate: DateTime.now().add(const Duration(days: 365)), // Max 365 days ahead
    );

    if (picked != null) {
      setState(() {
        // Update the departure date with the selected date
        departureDate = picked;
      });
    }
  }

  void _onSeatsPressed() async {
    final int? result = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => const SizedBox(
        height: 200,
        child: Placeholder(),
      ),
    );

    if (result != null) {
      setState(() {
        requestedSeats = result;
      });
    }
  }

  void _switchLocations() {
    setState(() {
      final temp = departure;
      departure = arrival;
      arrival = temp;
    });
  }

  void _onSearchPressed() {
    if (departure != null && arrival != null) {
      final newRidePref = RidePref(
        departure: departure!,
        arrival: arrival!,
        departureDate: departureDate,
        requestedSeats: requestedSeats,
      );
      Navigator.of(context).pop(newRidePref);
    }
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------

  // ----------------------------------
  // Build the widgets
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: BlaSpacings.m),
            child: Column(
              children: [
                // Departure field - MANDATORY (swap location)
                _buildFormRow(
                  icon: Icons.radio_button_off,
                  title: departure?.name ?? "Leaving from",
                  onPressed: _onDeparturePressed,
                  isMandatory: true,
                  isFilled: departure != null,
                  trailing: IconButton(
                    onPressed: _switchLocations,
                    icon: Icon(Icons.swap_vert, color: BlaColors.primary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(maxWidth: 48, maxHeight: 48),
                  ),
                ),
                const Divider(height: 1),
                // Arrival field - MANDATORY
                _buildFormRow(
                  icon: Icons.radio_button_off,
                  title: arrival?.name ?? "Going to",
                  onPressed: _onArrivalPressed,
                  isMandatory: true,
                  isFilled: arrival != null,
                ),
                const Divider(height: 1),
                // Date field - OPTIONAL
                _buildFormRow(
                  icon: Icons.calendar_month_outlined,
                  title: DateTimeUtils.formatDateTime(departureDate),
                  onPressed: _onDatePressed,
                  isMandatory: false,
                  isFilled: true,
                ),
                const Divider(height: 1),
                // Seats field - OPTIONAL
                _buildFormRow(
                  icon: Icons.person_outline,
                  title: requestedSeats.toString(),
                  onPressed: _onSeatsPressed,
                  isMandatory: false,
                  isFilled: true,
                ),
              ],
            ),
          ),

          // Search button with padding
          Padding(
            padding: const EdgeInsets.only(
              left: BlaSpacings.m,
              right: BlaSpacings.m,
              top: BlaSpacings.m,
              bottom: BlaSpacings.m,
            ),
            child: BlaButton(
              title: "Search",
              color: BlaColors.primary,
              icon: const Icon(Icons.search, color: Colors.white),
              onTap: _onSearchPressed,
            ),
          ),
        ]);
  }

  Widget _buildFormRow({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
    Widget? trailing,
    bool isMandatory = false,
    bool isFilled = true,
  }) {
    final isPlaceholder = title == "Leaving from" || title == "Going to";
    final textColor = isPlaceholder ? BlaColors.neutralLighter : BlaColors.neutralDark;
    
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: BlaSpacings.m),
        child: Row(
          children: [
            // Icon with mandatory indicator for required fields
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, color: BlaColors.neutralLight, size: 24),
                if (isMandatory && !isFilled)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: BlaColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: BlaSpacings.m),
            Expanded(
              child: Text(
                title,
                style: BlaTextStyles.body.copyWith(color: textColor),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
