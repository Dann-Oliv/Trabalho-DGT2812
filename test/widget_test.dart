import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explore_mundo/main.dart';

void main() {
  testWidgets('exibe destinos e pesquisa', (tester) async {
    await tester.pumpWidget(const ExploreMundoApp());

    expect(find.text('Explore Mundo'), findsOneWidget);
    expect(find.text('Oeschinen Lake'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Fernando de Noronha'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Fernando de Noronha'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Santorini');
    await tester.pump();

    expect(find.text('Santorini'), findsOneWidget);
    expect(find.text('Oeschinen Lake'), findsNothing);
  });
}
