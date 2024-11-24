import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/widgets/app_drawer.dart';

void main() {
  testWidgets('AppDrawer smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => new Auth(),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
              appBar: AppBar(title: const Text('Drawer test')),
              drawer: const AppDrawer()),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("AppBar")), findsOneWidget);
    expect(find.text("Bem vindo Usúario"), findsOneWidget);

    expect(find.text('Loja'), findsOneWidget);
    expect(find.text('Pedidos'), findsOneWidget);
    expect(find.text('Gerencia Produtos'), findsOneWidget);
    expect(find.text('Sair'), findsOneWidget);

    expect(find.text('Loja'), findsOneWidget);
  });
}
