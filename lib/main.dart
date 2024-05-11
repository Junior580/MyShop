import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'utils/app_routes.dart';
import 'views/products_overview_screen.dart';
import 'views/product_detail_screen.dart';

import 'providers/cart.dart';
import 'providers/products.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        )
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
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailScreen()
        },
      ),
    );
  }
}
