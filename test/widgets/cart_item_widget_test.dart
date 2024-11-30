import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/widgets/cart_item_widget.dart';

void main() {
  testWidgets('CartItemWidget smoke test', (WidgetTester tester) async {
    final cart = Cart();

    const cartItem = CartItem(
      id: 'c1',
      productId: 'p1',
      title: 'Produto Teste',
      quantity: 2,
      price: 10.0,
    );

    final product = Product(
      id: 'p1',
      title: 'Produto Teste',
      description: 'Descrição do produto teste',
      price: 10.0,
      imageUrl: 'https://example.com/produto.jpg',
    );

    cart.addItem(product);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: cart,
        child: const MaterialApp(
          home: Scaffold(
            body: CartItemWidget(cartItem: cartItem),
          ),
        ),
      ),
    );

    expect(find.text('Produto Teste'), findsOneWidget);

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Tem certeza?'), findsOneWidget);
    expect(find.text('Quer remover o item do carrinho'), findsOneWidget);

    await tester.tap(find.text('Sim'));
    await tester.pumpAndSettle();

    expect(cart.items.containsKey('p1'), isFalse);
  });

  testWidgets('CartItemWidget it should cancel the removal by clicking "No"',
      (WidgetTester tester) async {
    final cart = Cart();

    const cartItem = CartItem(
      id: 'c1',
      productId: 'p1',
      title: 'Produto Teste',
      quantity: 2,
      price: 10.0,
    );

    final product = Product(
      id: 'p1',
      title: 'Produto Teste',
      description: 'Descrição do produto teste',
      price: 10.0,
      imageUrl: 'https://example.com/produto.jpg',
    );

    cart.addItem(product);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: cart,
        child: const MaterialApp(
          home: Scaffold(
            body: CartItemWidget(cartItem: cartItem),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Tem certeza?'), findsOneWidget);

    await tester.tap(find.text('Não'));
    await tester.pumpAndSettle();

    expect(cart.items.containsKey('p1'), isTrue);
  });
}
