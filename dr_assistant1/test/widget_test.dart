import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dr_assistant1/main.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(isDark: false));
    expect(find.text('Dr. Assistant'), findsOneWidget);
    });
}