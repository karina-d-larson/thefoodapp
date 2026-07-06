import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:the_home_cook/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('meal planning shell shows pantry and recipe areas', (
    tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('The Home Cook'), findsWidgets);
    expect(find.text('Pantry Management'), findsOneWidget);
    expect(find.text('Recipe Library'), findsOneWidget);
    expect(find.text('Meal Planning'), findsOneWidget);
  });
}
