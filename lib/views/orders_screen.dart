import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const AppDrawer(),
    );
  }
}
