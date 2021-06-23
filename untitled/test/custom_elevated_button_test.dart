import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/common_widgets/custom_elevated_button.dart';

void main() {
  testWidgets('onPressed Callback', (WidgetTester tester) async {
    bool pressed = false;
    await tester.pumpWidget(MaterialApp(
      home: CustomElevatedButton(
        child: Text('Ugh'),
        onPressed: () => pressed = true,
      ),
    ));
    final Finder button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
    expect(find.text('Ugh'), findsOneWidget);
    await tester.tap(button);
    expect(pressed, true);
  });
}
