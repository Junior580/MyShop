import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

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
  final String _baseUrl = '${Constants.BASE_API_URL}/orders';
  List<Order> _items = [];

  final String? _token;
  final String? _userId;

  Orders([this._token, this._userId, this._items = const []]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];
    final response =
        await http.get(Uri.parse("$_baseUrl/$_userId.json?auth=$_token"));
    Map<String, dynamic> data = json.decode(response.body);

    data.forEach((orderId, orderData) {
      loadedItems.add(
        Order(
          id: orderId,
          total: orderData['total'] is double
              ? orderData['total']
              : double.parse(orderData['total'].toString()),
          date: DateTime.parse(orderData['date']),
          // products: products,
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              price: item['price'] is double
                  ? item['price']
                  : double.parse(item['price'].toString()),
              productId: item['productId'],
              quantity: item['quantity'] is int
                  ? item['quantity']
                  : int.parse(item['quantity'].toString()),
              title: item['title'],
            );
          }).toList(),
        ),
      );
    });

    notifyListeners();

    _items = loadedItems.reversed.toList();

    return Future.value();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse("$_baseUrl/$_userId.json?auth=$_token"),
      body: json.encode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList()
      }),
    );

    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }
}
