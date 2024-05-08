import 'package:flutter/material.dart';
import './views/products_overview_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Loja',
      theme: ThemeData(
        fontFamily: 'Lato',
        primarySwatch: Colors.purple,
        colorScheme:
            const ColorScheme.light().copyWith(secondary: Colors.deepOrange),
      ),
      home: ProductOverviewScreen(),
    );
  }
}
