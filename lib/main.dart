// ignore_for_file: unnecessary_new

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'utils/app_routes.dart';
import 'views/products_overview_screen.dart';
import 'views/product_detail_screen.dart';
import 'views/cart_screen.dart';
import 'views/orders_screen.dart';

import 'providers/cart.dart';
import 'providers/products.dart';
import 'providers/orders.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Orders(),
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
        home: const ProductOverviewScreen(),
        routes: {
          AppRoutes.ORDERS: (ctx) => const OrdersScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailScreen(),
          AppRoutes.CART: (ctx) => const CartScreen()
        },
      ),
    );
  }
}
