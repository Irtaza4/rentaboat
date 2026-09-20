import 'package:flutter_test/flutter_test.dart';
import 'package:rentboat/main.dart';

void main() {
  testWidgets('App renders scenic Splash screen and navigates to Home', (WidgetTester tester) async {
    await tester.pumpWidget(const RentBoatApp());
    expect(find.text('Rent a boat'), findsOneWidget);
    expect(find.text('Explore Boats'), findsOneWidget);

    // Fast forward splash sequence
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Verify Home screen is visible
    expect(find.text('Rent a boat'), findsOneWidget);
    expect(find.text('Lifetime Youth'), findsOneWidget);
  });
}
