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
import 'package:pumpkin/screens/authentication/confirm_mobile_screen.dart';
import 'package:pumpkin/screens/authentication/signup_screen.dart';
import 'package:pumpkin/screens/profile/my_profile_screen.dart';

void main() {
  testWidgets('my profile widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: MyProfileScreen()));

    // Verify widgets
    expect(find.byKey(const Key("Option")), findsWidgets);
    expect(find.byKey(const Key("switch")), findsWidgets);
    await tester.pump();
  });
}
