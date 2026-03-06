import 'package:bloc_weather_api/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Weather page renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('SkyCast'), findsOneWidget);
    expect(
      find.text('Search for a city to reveal live weather'),
      findsOneWidget,
    );
  });
}
