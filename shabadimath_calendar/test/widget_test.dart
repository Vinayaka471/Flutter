// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:shabadimath_calendar/providers/app_state.dart';
import 'package:shabadimath_calendar/screens/home_screen.dart';

void main() {
  testWidgets('Home screen renders primary actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.text('Kannada Calendar'), findsOneWidget);
    expect(find.text('Open Calendar'), findsOneWidget);
  });
}
