import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pumpkin/screens/authentication/2fa_code_screen.dart';
import 'package:pumpkin/widgets/buttons/button_type_one.dart';

void main() {
  testWidgets('Login screen widget test', (WidgetTester tester) async {
    // Triggering a frame
    await tester.pumpWidget(const MaterialApp(home: TwoFactorScreen()));

    var sizedBox = find.byType(SizedBox);
    var text = find.byType(Text);
    var button = find.byType(TextButton);
    var myButton = find.byType(ButtonTypeOne);
    var image = find.byType(Image);

    // Verify widgets
    expect(sizedBox, findsWidgets);
    expect(text, findsWidgets);
    expect(button, findsWidgets);
    expect(myButton, findsWidgets);
    expect(image, findsWidgets);

    await tester.pump();
  });
}
