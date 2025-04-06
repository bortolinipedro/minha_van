import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minha_van/main.dart';
import 'package:minha_van/i18n/main_i18n.dart';

void main() {
  testWidgets('Initial Options screen test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Options()));

    // Verify that main buttons are present
    expect(find.text(MainI18n.iAmADriver), findsOneWidget);
    expect(find.text(MainI18n.iAmAPassenger), findsOneWidget);

    // Test navigation to driver screen
    await tester.tap(find.text(MainI18n.iAmADriver));
    await tester.pumpAndSettle();

    // Test navigation to passenger screen
    await tester.tap(find.text(MainI18n.iAmAPassenger));
    await tester.pumpAndSettle();

    // Test about app text is present
    expect(find.text('Sobre o app'), findsOneWidget);
  });
}
