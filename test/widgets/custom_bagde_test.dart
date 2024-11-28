import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop/widgets/custom_bagde.dart';

void main() {
  testWidgets('CustomBadge renders correctly with default color',
      (WidgetTester tester) async {
    const childWidget = Icon(Icons.shopping_cart);
    const badgeValue = '5';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomBadge(
            value: badgeValue,
            child: childWidget,
          ),
        ),
      ),
    );

    expect(find.byType(Icon), findsOneWidget);
    expect(find.text(badgeValue), findsOneWidget);
    final container = tester.widget<Container>(find.byType(Container).last);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, equals(ThemeData().colorScheme.secondary));
  });

  testWidgets('CustomBadge uses custom color when provided',
      (WidgetTester tester) async {
    const childWidget = Icon(Icons.shopping_cart);
    const badgeValue = '10';
    const customColor = Colors.red;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomBadge(
            value: badgeValue,
            color: customColor,
            child: childWidget,
          ),
        ),
      ),
    );

    expect(find.byType(Icon), findsOneWidget);
    expect(find.text(badgeValue), findsOneWidget);
    final container = tester.widget<Container>(find.byType(Container).last);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, equals(customColor));
  });

  testWidgets('CustomBadge respects value and text alignment',
      (WidgetTester tester) async {
    const badgeValue = '99+';
    const childWidget = Icon(Icons.notifications);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomBadge(
            value: badgeValue,
            child: childWidget,
          ),
        ),
      ),
    );

    expect(find.text(badgeValue), findsOneWidget);
    final text = tester.widget<Text>(find.text(badgeValue));
    expect(text.style?.fontSize, equals(10));
    expect(text.textAlign, equals(TextAlign.center));
  });
}
