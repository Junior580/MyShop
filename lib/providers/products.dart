import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'product.dart';
import '../data/dummy_data.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final _baseUrl = Uri.parse('');
  final List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get(_baseUrl);
    Map<String, dynamic> data = json.decode(response.body);

    _items.clear();
    data.forEach((productId, productData) {
      _items.add(Product(
        id: productId,
        title: productData['title'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
        isFavorite: productData['isFavorite'],
      ));
    });
    notifyListeners();
    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    final response = await http.post(
      _baseUrl,
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
    );

    _items.add(Product(
      id: json.decode(response.body)['name'],
      title: newProduct.title,
      description: newProduct.description,
      price: newProduct.price,
      imageUrl: newProduct.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      await http.patch(
        _baseUrl.replace(query: product.id),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(_baseUrl.replace(query: product.id));

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw const HttpException('Ocorreu um erro na exclusão do produto.');
      }
    }
  }
}
