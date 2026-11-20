import 'package:flutter_test/flutter_test.dart';
import 'package:kormi/main.dart';

void main() {
  testWidgets('KORMI app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const KormiApp());
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('KORMI'), findsOneWidget);
  });
}
