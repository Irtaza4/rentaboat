import 'package:flutter_test/flutter_test.dart';
import 'package:rentboat/main.dart';

void main() {
  testWidgets('App renders Home screen with title and boats', (WidgetTester tester) async {
    await tester.pumpWidget(const RentBoatApp());
    await tester.pumpAndSettle();

    // Verify 'Rent a boat' title is rendered
    expect(find.text('Rent a boat'), findsOneWidget);
    // Verify boat cards
    expect(find.text('Lifetime Youth'), findsOneWidget);
    expect(find.text('Sunny Island'), findsOneWidget);
  });
}
