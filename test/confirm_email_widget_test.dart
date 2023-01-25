// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pumpkin/main.dart';
import 'package:pumpkin/screens/authentication/confirm_email_screen.dart';
import 'package:pumpkin/screens/authentication/signup_screen.dart';

void main() {
  testWidgets('confirm email widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ConfirmEmailScreen()));

    // Verify widgets
    expect(find.byKey(const Key("verify")), findsOneWidget);
    expect(find.byKey(const Key("otp")), findsOneWidget);
    await tester.pump();
  });
}
