import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_home_cook/main.dart';

void main() {
  testWidgets('pantry dashboard shows The Home Cook title', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HomeCookApp()));
    await tester.pumpAndSettle();

    expect(find.text('The Home Cook'), findsWidgets);
    expect(find.text('Pantry Management'), findsOneWidget);
    expect(find.text('Recipe Library'), findsOneWidget);
    expect(find.text('Meal Planning'), findsOneWidget);
  });
}
