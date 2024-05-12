import 'dart:math';

import 'package:flutter/material.dart';

import './cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });
}

class Orders with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return [...orders];
  }

  void addOrder(Cart cart) {
    _orders.insert(
      0,
      Order(
        id: Random().nextDouble().toString(),
        total: double.parse(cart.totalAmount),
        products: cart.items.values.toList(),
        date: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
