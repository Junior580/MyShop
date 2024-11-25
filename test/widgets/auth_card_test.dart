import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/widgets/auth_card.dart';

class MockAuth extends Mock implements Auth {}

void main() {
  late MockAuth mockAuth;
  late MockNavigator navigator;

  setUp(() {
    mockAuth = MockAuth();
    navigator = MockNavigator();

    when(() => mockAuth.login(any(), any()))
        .thenAnswer((_) async => Future.value());
    when(() => mockAuth.signup(any(), any()))
        .thenAnswer((_) async => Future.value());
    when(navigator.canPop).thenReturn(false);
    when(() => navigator.pushReplacementNamed(any())).thenAnswer((_) async {});
  });

  testWidgets('AuthCard should switch between login and signup',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>.value(value: mockAuth),
        ],
        child: MaterialApp(
          home: MockNavigatorProvider(
            navigator: navigator,
            child: const Scaffold(
              body: AuthCard(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Entrar'), findsOneWidget);

    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(find.text('REGISTRAR'), findsOneWidget);

    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets(
      'AuthCard should call login method when form is valid and Login mode is selected',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>.value(value: mockAuth),
        ],
        child: MaterialApp(
          home: MockNavigatorProvider(
            navigator: navigator,
            child: const Scaffold(
              body: AuthCard(),
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'test@test.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    verify(() => mockAuth.login('test@test.com', 'password123')).called(1);
  });

  testWidgets(
      'AuthCard should call signup method when form is valid and Signup mode is selected',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>.value(value: mockAuth),
        ],
        child: MaterialApp(
          home: MockNavigatorProvider(
            navigator: navigator,
            child: const Scaffold(
              body: AuthCard(),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextButton));
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).first, 'test@test.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    verify(() => mockAuth.signup('test@test.com', 'password123')).called(1);
  });

  testWidgets('AuthCard should show error dialog when login fails',
      (WidgetTester tester) async {
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
            child: const Scaffold(
              body: AuthCard(),
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'test@test.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Ocorreu um error'), findsOneWidget);
  });

  testWidgets('AuthCard should show error dialog for unexpected errors',
      (WidgetTester tester) async {
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
            child: const Scaffold(
              body: AuthCard(),
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'test@test.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Ocorreu um erro inesperado.'), findsOneWidget);
  });
}
