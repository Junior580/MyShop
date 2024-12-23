import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/views/auth_home_screen.dart';
import 'package:shop/views/product_form_screen.dart';

import 'utils/app_routes.dart';

import 'views/product_detail_screen.dart';
import 'views/cart_screen.dart';
import 'views/orders_screen.dart';
import 'views/products_screen.dart';
import 'providers/cart.dart';
import 'providers/products.dart';
import 'providers/orders.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => new Products(),
          update: (ctx, auth, previousProducts) => new Products(
            auth.token,
            auth.userId,
            previousProducts?.items ?? [],
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => new Orders(),
          update: (context, value, previous) =>
              new Orders(value.token, value.userId, previous?.items ?? []),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: Colors.purple,
          colorScheme: const ColorScheme.light().copyWith(
            secondary: Colors.deepOrange,
          ),
        ),
        routes: {
          AppRoutes.AUTH_HOME: (ctx) => const AuthOrHomeScreen(),
          AppRoutes.ORDERS: (ctx) => const OrdersScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailScreen(),
          AppRoutes.CART: (ctx) => const CartScreen(),
          AppRoutes.PRODUCTS: (ctx) => const ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => const ProductFormScreen()
        },
      ),
    );
  }
}
