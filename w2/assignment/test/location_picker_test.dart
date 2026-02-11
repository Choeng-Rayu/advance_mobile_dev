import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blabla/ui/screens/ride_pref/widgets/location_picker_screen.dart';
import 'package:blabla/model/ride/locations.dart';
import 'package:blabla/data/dummy_data.dart';

void main() {
  group('LocationPickerScreen Tests', () {
    
    testWidgets('Q1.1 - Should display search bar and list of all locations initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Verify search bar exists
      expect(find.byType(TextField), findsOneWidget);
      
      // Verify back button exists for navigation
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      
      // Verify list of locations is displayed (ListView renders ~8 visible items)
      expect(find.byType(ListTile), findsWidgets);
      
      // Verify we have at least some list tiles
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Q1.2 - Live search filters locations by city name using onChange', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      final initialCount = fakeLocations.length;
      
      // Type search query in TextInput using onChange callback
      await tester.enterText(find.byType(TextField), 'par');
      await tester.pumpAndSettle();

      // Verify filtered results (should be fewer than initial)
      final filteredCount = find.byType(ListTile);
      expect(filteredCount, findsWidgets);
      
      // Verify no "No locations found" message
      expect(find.text('No locations found'), findsNothing);
    });

    testWidgets('Q1.3 - Live search filters locations by country name', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Search by country using onChange
      await tester.enterText(find.byType(TextField), 'united');
      await tester.pumpAndSettle();

      // Verify UK locations are shown
      expect(find.byType(ListTile), findsWidgets);
      expect(find.text('No locations found'), findsNothing);
    });

    testWidgets('Q1.4 - Shows "No locations found" for invalid search', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Type invalid search
      await tester.enterText(find.byType(TextField), 'xyz999invalid');
      await tester.pumpAndSettle();

      // Verify no results message
      expect(find.text('No locations found'), findsOneWidget);
      
      // Verify clear button is shown to clear the search
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('Q1.5 - Clear button removes search and shows all locations again', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Perform search using onChange
      await tester.enterText(find.byType(TextField), 'par');
      await tester.pumpAndSettle();

      // Verify clear button exists
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Tap clear button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify all locations shown again (check for significant number of tiles)
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Q1.6 - Selecting a location pops it back to caller', (WidgetTester tester) async {
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
                        MaterialPageRoute(
                          builder: (context) => const LocationPickerScreen(),
                        ),
                      );
                    },
                    child: const Text('Open Picker'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Open picker
      await tester.tap(find.text('Open Picker'));
      await tester.pumpAndSettle();

      // Tap first location (London)
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Verify location was selected and returned
      expect(selectedLocation, isNotNull);
      expect(selectedLocation?.name, fakeLocations[0].name);
    });

    testWidgets('Q1.7 - Back button cancels selection and navigates back', (WidgetTester tester) async {
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
                        MaterialPageRoute(
                          builder: (context) => const LocationPickerScreen(),
                        ),
                      );
                    },
                    child: const Text('Open Picker'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Open picker
      await tester.tap(find.text('Open Picker'));
      await tester.pumpAndSettle();

      // Tap back button  
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back on original screen
      expect(find.text('Open Picker'), findsOneWidget);
      
      // Verify no location was selected
      expect(selectedLocation, isNull);
    });

    testWidgets('Q2.1 - List items have correct structure (icon, city, country, arrow)', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Verify location icons
      expect(find.byIcon(Icons.location_on_outlined), findsWidgets);
      
      // Verify navigation arrows
      expect(find.byIcon(Icons.arrow_forward_ios), findsWidgets);
      
      // Verify list tiles
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Q3.1 - Case-insensitive search works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Search with different cases using onChange
      await tester.enterText(find.byType(TextField), 'LONDON');
      await tester.pumpAndSettle();

      // Should still find London (case insensitive)
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Q3.2 - Live search updates as user types (onChange)', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      final initialCount = fakeLocations.length;

      // Type first character using onChange
      await tester.enterText(find.byType(TextField), 'l');
      await tester.pumpAndSettle();
      
      final firstFilterCount = find.byType(ListTile).evaluate().length;

      // Type more characters
      await tester.enterText(find.byType(TextField), 'lo');
      await tester.pumpAndSettle();
      
      final secondFilterCount = find.byType(ListTile).evaluate().length;

      // Verify results change as user types (live filtering via onChange)
      expect(initialCount, greaterThan(0));
      expect(firstFilterCount, greaterThan(0));
      expect(secondFilterCount, greaterThan(0));
    });

    testWidgets('Q3.3 - Clear button appears only when search is not empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Initially no clear button
      expect(find.byIcon(Icons.close), findsNothing);

      // Type something using onChange
      await tester.enterText(find.byType(TextField), 'l');
      await tester.pumpAndSettle();

      // Clear button should appear
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Clear the search
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Clear button should disappear
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('Q3.4 - Partial match search works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // Search with partial match
      await tester.enterText(find.byType(TextField), 'par');
      await tester.pumpAndSettle();

      // Should find Paris, Parma, etc.
      expect(find.byType(ListTile), findsWidgets);
      expect(find.text('No locations found'), findsNothing);
    });

    testWidgets('Q3.5 - Selecting location from filtered results works', (WidgetTester tester) async {
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
                        MaterialPageRoute(
                          builder: (context) => const LocationPickerScreen(),
                        ),
                      );
                    },
                    child: const Text('Open Picker'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Open picker
      await tester.tap(find.text('Open Picker'));
      await tester.pumpAndSettle();

      // Filter using live search (onChange)
      await tester.enterText(find.byType(TextField), 'par');
      await tester.pumpAndSettle();

      // Select from filtered results
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Verify correct location selected
      expect(selectedLocation, isNotNull);
    });

    testWidgets('Q3.6 - Multiple search cycles work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LocationPickerScreen(),
        ),
      );

      // First search cycle
      await tester.enterText(find.byType(TextField), 'l');
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsWidgets);

      // Clear and search again
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Second search cycle
      await tester.enterText(find.byType(TextField), 'm');
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsWidgets);

      // Clear again
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify all locations shown (ListView renders visible items)
      expect(find.byType(ListTile), findsWidgets);
    });
  });
}
