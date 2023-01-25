import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pumpkin/screens/authentication/login_screen.dart';

void main() {
  testWidgets('Login screen widget test', (WidgetTester tester) async {
    // Triggering a frame
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    var textField = find.byType(TextField);
    var sizedBox = find.byType(SizedBox);
    var text = find.byType(Text);
    var button = find.byType(TextButton);
    var tab = find.byType(TabBar);

    // Verify widgets
    expect(find.byKey(const Key("password")), findsOneWidget);
    expect(find.byKey(const Key("signIn")), findsOneWidget);
    expect(textField, findsWidgets);
    expect(sizedBox, findsWidgets);
    expect(text, findsWidgets);
    expect(button, findsWidgets);
    expect(tab, findsOneWidget);

    await tester.pump();
  });
}
