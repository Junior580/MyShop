import 'package:flutter/material.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ModalRoute? modalRoute = ModalRoute.of(context);
    final product = modalRoute?.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
