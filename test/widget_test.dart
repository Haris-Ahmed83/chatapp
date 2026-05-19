import 'package:flutter_test/flutter_test.dart';

import 'package:chato/src/app.dart';

void main() {
  testWidgets('App widgets build without error', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(App), findsOneWidget);
  });
}
