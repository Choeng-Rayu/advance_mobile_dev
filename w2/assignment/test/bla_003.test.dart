import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:assignment/ui/screens/ride_pref/widgets/ride_prefs_form.dart';
import '../lib/ui/screens/ride_pref/widgets/ride_prefs_form.dart';

void main() {
  testWidgets('RidePrefForm renders and interacts', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RidePrefForm(),
        ),
      ),
    );

    // Check that all form fields are present
    expect(find.text('Leaving from'), findsOneWidget);
    expect(find.text('Going to'), findsOneWidget);
    expect(find.byIcon(Icons.calendar_month_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);

    // Tap on the Search button (should not pop since fields are empty)
    await tester.tap(find.text('Search'));
    await tester.pump();

    // Tap on the departure field (should navigate to placeholder)
    await tester.tap(find.text('Leaving from'));
    await tester.pumpAndSettle();

    // Go back to the form
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Tap on the arrival field (should navigate to placeholder)
    await tester.tap(find.text('Going to'));
    await tester.pumpAndSettle();

    // Go back to the form
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Tap on the date field (should open date picker)
    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();

    // Tap on the seats field (should open bottom sheet)
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
  });
}