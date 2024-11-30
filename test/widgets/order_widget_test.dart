import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/order_widget.dart';

void main() {
  group('OrderWidget Tests', () {
    late Order testOrder;

    setUp(() {
      testOrder = Order(
        id: 'o1',
        total: 59.99,
        date: DateTime.now(),
        products: [
          const CartItem(
            id: 'c1',
            title: 'Test Product 1',
            quantity: 2,
            price: 29.99,
            productId: 'p1',
          ),
        ],
      );
    });

    testWidgets('displays total and date correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderWidget(testOrder),
          ),
        ),
      );

      expect(find.text('R\$ 59.99'), findsOneWidget); // Total value
      expect(
        find.text(DateFormat('dd/MM/yyyy hh:mm').format(testOrder.date)),
        findsOneWidget, // Formatted date
      );
    });

    testWidgets('toggles expanded details when expand button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderWidget(testOrder),
          ),
        ),
      );

      expect(find.text('Test Product 1'), findsNothing); // Details hidden

      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pumpAndSettle(); // Wait for animations to complete

      expect(find.text('Test Product 1'), findsOneWidget); // Details visible
      expect(find.text('2 x R\$ 29.99'), findsOneWidget); // Product details
    });

    testWidgets('renders correct number of products when expanded',
        (WidgetTester tester) async {
      final multiProductOrder = Order(
        id: 'o2',
        total: 150.00,
        date: DateTime.now(),
        products: [
          const CartItem(
            id: 'c1',
            title: 'Product 1',
            quantity: 1,
            price: 50.00,
            productId: 'p1',
          ),
          const CartItem(
            id: 'c2',
            title: 'Product 2',
            quantity: 2,
            price: 50.00,
            productId: 'p2',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderWidget(multiProductOrder),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.expand_more));
      await tester.pumpAndSettle();

      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Product 2'), findsOneWidget);
      expect(find.text('1 x R\$ 50.0'), findsOneWidget);
      expect(find.text('2 x R\$ 50.0'), findsOneWidget);
    });
  });
}
