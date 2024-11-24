import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/widgets/app_drawer.dart';

void main() {
  testWidgets('AppDrawer smoke test', (WidgetTester tester) async {
    final navigator = MockNavigator();
    when(navigator.canPop).thenReturn(false);
    when(() => navigator.pushReplacementNamed(any())).thenAnswer((_) async {});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => new Auth(),
          ),
        ],
        child: MaterialApp(
          home: MockNavigatorProvider(
            navigator: navigator,
            child: Scaffold(
              appBar: AppBar(title: const Text('Drawer test')),
              drawer: const AppDrawer(),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("AppBar")), findsOneWidget);
    expect(find.text("Bem vindo Usúario"), findsOneWidget);

    expect(find.text('Loja'), findsOneWidget);
    await tester.tap(find.text('Loja'));
    await tester.pumpAndSettle();
    verify(() => navigator.pushReplacementNamed(AppRoutes.AUTH_HOME)).called(1);

    expect(find.text('Pedidos'), findsOneWidget);
    await tester.tap(find.text('Pedidos'));
    await tester.pumpAndSettle();
    verify(() => navigator.pushReplacementNamed(AppRoutes.ORDERS)).called(1);

    expect(find.text('Gerencia Produtos'), findsOneWidget);
    await tester.tap(find.text('Gerencia Produtos'));
    await tester.pumpAndSettle();
    verify(() => navigator.pushReplacementNamed(AppRoutes.PRODUCTS)).called(1);

    expect(find.text('Sair'), findsOneWidget);
    // await tester.tap(find.text('Loja'));
    // await tester.pumpAndSettle();
    // verify(() => navigator.pushReplacementNamed(AppRoutes.AUTH_HOME)).called(1);
  });
}
