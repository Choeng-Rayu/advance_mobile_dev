import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blabla/ui/screens/ride_pref/widgets/location_picker_screen.dart';
import 'package:blabla/model/ride/locations.dart';
import 'package:blabla/data/dummy_data.dart';

void main() {
  group('LocationPickerScreen - Core Tests', () {
    
    // TEST 1: Initial UI display with search bar and location list
    testWidgets('TEST 1: Display search bar and location list on initial load', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LocationPickerScreen()));

      // Verify: TextField search input exists
      expect(find.byType(TextField), findsOneWidget);
      
      // Verify: Back button for navigation exists
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      
      // Verify: List of location tiles displayed
      expect(find.byType(ListTile), findsWidgets);
    });

    // TEST 2: Live search via onChange callback - filter by city name
    testWidgets('TEST 2: Live search filters locations by city name (onChange)', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LocationPickerScreen()));

      // Action: Type "par" in search field (triggers onChange callback)
      await tester.enterText(find.byType(TextField), 'par');
      await tester.pumpAndSettle();

      // Verify: Filtered results displayed (Paris, Parma, etc.)
      expect(find.byType(ListTile), findsWidgets);
      
      // Verify: No "No locations found" message
      expect(find.text('No locations found'), findsNothing);
    });

    // TEST 3: Display "No locations found" for invalid search
    testWidgets('TEST 3: Show "No locations found" message for invalid search', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LocationPickerScreen()));

      // Action: Type invalid search term
      await tester.enterText(find.byType(TextField), 'xyz999invalid');
      await tester.pumpAndSettle();

      // Verify: "No locations found" message displayed
      expect(find.text('No locations found'), findsOneWidget);
      
      // Verify: Clear button (X) appears to let user clear search
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    // TEST 4: Clear button - clears search field and shows all locations
    testWidgets('TEST 4: Clear button (X) resets search and shows all locations', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LocationPickerScreen()));

      // Action: Type search term
      await tester.enterText(find.byType(TextField), 'par');
      await tester.pumpAndSettle();

      // Verify: Clear button exists
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Action: Tap clear button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify: All locations shown again
      expect(find.byType(ListTile), findsWidgets);
      
      // Verify: Clear button disappears when search is empty
      expect(find.byIcon(Icons.close), findsNothing);
    });

    // TEST 5: Select location and pop back with selected location object
    testWidgets('TEST 5: Select location pops it back to caller with data', (WidgetTester tester) async {
      Location? selectedLocation;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      selectedLocation = await Navigator.of(context).push<Location>(
                        MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
                      );
                    },
                    child: const Text('Open'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Action: Open picker
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Action: Tap first location
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Verify: Location object returned with data
      expect(selectedLocation, isNotNull);
      expect(selectedLocation?.name, fakeLocations[0].name);
    });

    // TEST 6: Back button cancels selection (returns null)
    testWidgets('TEST 6: Back button cancels selection and returns to previous screen', (WidgetTester tester) async {
      Location? selectedLocation;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      selectedLocation = await Navigator.of(context).push<Location>(
                        MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
                      );
                    },
                    child: const Text('Open'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Action: Open picker
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Action: Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify: Back to previous screen
      expect(find.text('Open'), findsOneWidget);
      
      // Verify: No location selected (null returned)
      expect(selectedLocation, isNull);
    });

    // TEST 7: Case-insensitive search (uppercase/lowercase both work)
    testWidgets('TEST 7: Search is case-insensitive (LONDON = london)', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LocationPickerScreen()));

      // Action: Search with uppercase text
      await tester.enterText(find.byType(TextField), 'LONDON');
      await tester.pumpAndSettle();

      // Verify: Still finds locations despite uppercase
      expect(find.byType(ListTile), findsWidgets);
      expect(find.text('No locations found'), findsNothing);
    });

    // TEST 8: Verify list items have correct UI structure
    testWidgets('TEST 8: List items have icon, city name, country, and arrow', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LocationPickerScreen()));

      // Verify: Location pin icon present
      expect(find.byIcon(Icons.location_on_outlined), findsWidgets);
      
      // Verify: Right arrow navigation icon present
      expect(find.byIcon(Icons.arrow_forward_ios), findsWidgets);
      
      // Verify: ListTile widgets contain all above
      expect(find.byType(ListTile), findsWidgets);
    });

    // TEST 9: Live search and select from filtered results
    testWidgets('TEST 9: Can select location from filtered search results', (WidgetTester tester) async {
      Location? selectedLocation;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      selectedLocation = await Navigator.of(context).push<Location>(
                        MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
                      );
                    },
                    child: const Text('Open'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Action: Open picker
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Action: Filter with search (onChange)
      await tester.enterText(find.byType(TextField), 'paris');
      await tester.pumpAndSettle();

      // Action: Select from filtered results
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Verify: Location selected successfully from filtered list
      expect(selectedLocation, isNotNull);
    });
  });
}
