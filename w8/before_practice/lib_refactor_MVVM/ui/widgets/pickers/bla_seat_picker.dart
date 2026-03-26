import 'package:flutter/material.dart';

/// A Seat Picker widget for selecting number of seats
class BlaSeatsPickerModal extends StatefulWidget {
  const BlaSeatsPickerModal({
    super.key,
    required this.initialSeats,
    this.maxSeats = 5,
    this.minSeats = 1,
  });

  final int initialSeats;
  final int maxSeats;
  final int minSeats;

  @override
  State<BlaSeatsPickerModal> createState() => _BlaSeatsPickerModalState();
}

class _BlaSeatsPickerModalState extends State<BlaSeatsPickerModal> {
  late int selectedSeats;

  @override
  void initState() {
    super.initState();
    selectedSeats = widget.initialSeats;
  }

  void _incrementSeats() {
    if (selectedSeats < widget.maxSeats) {
      setState(() => selectedSeats++);
    }
  }

  void _decrementSeats() {
    if (selectedSeats > widget.minSeats) {
      setState(() => selectedSeats--);
    }
  }

  void _confirmSelection() {
    Navigator.pop<int>(context, selectedSeats);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Select Number of Seats',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // Seat Counter
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minus Button
                IconButton.filled(
                  onPressed: selectedSeats > widget.minSeats
                      ? _decrementSeats
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: 24),

                // Seat Count Display
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '$selectedSeats',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),

                // Plus Button
                IconButton.filled(
                  onPressed: selectedSeats < widget.maxSeats
                      ? _incrementSeats
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Info Text
            Text(
              'Available seats: ${widget.minSeats} - ${widget.maxSeats}',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmSelection,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple seat picker widget that can be embedded in other screens
class BlaSeatsPicker extends StatefulWidget {
  const BlaSeatsPicker({
    super.key,
    required this.selectedSeats,
    required this.onSeatsChanged,
    this.maxSeats = 5,
    this.minSeats = 1,
  });

  final int selectedSeats;
  final ValueChanged<int> onSeatsChanged;
  final int maxSeats;
  final int minSeats;

  @override
  State<BlaSeatsPicker> createState() => _BlaSeatsPickerState();
}

class _BlaSeatsPickerState extends State<BlaSeatsPicker> {
  late int seats;

  @override
  void initState() {
    super.initState();
    seats = widget.selectedSeats;
  }

  void _incrementSeats() {
    if (seats < widget.maxSeats) {
      setState(() => seats++);
      widget.onSeatsChanged(seats);
    }
  }

  void _decrementSeats() {
    if (seats > widget.minSeats) {
      setState(() => seats--);
      widget.onSeatsChanged(seats);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Seats',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              // Minus Button
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: seats > widget.minSeats ? _decrementSeats : null,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
              ),

              // Count Display
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    '$seats',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Plus Button
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: seats < widget.maxSeats ? _incrementSeats : null,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
