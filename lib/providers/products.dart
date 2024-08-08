import 'dart:convert';
import 'package:shop/exceptions/http_exception.dart';

import 'package:flutter/material.dart';
import 'package:shop/utils/constants.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/products';
  // ignore: prefer_final_fields
  List<Product> _items = [];
  // ignore: prefer_final_fields
  String? _token;
  final String? _userId;

  Products([this._token, this._userId, this._items = const []]);

  List<Product> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse("$_baseUrl.json?auth=$_token"));
    Map<String, dynamic> data = json.decode(response.body);

    final favResp = await http.get(Uri.parse(
        "${Constants.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token"));
    final favMap = json.decode(favResp.body);

    _items.clear();

    data.forEach((productId, productData) {
      final isFavorite = favMap == null ? false : favMap[productId] ?? false;

      _items.add(Product(
        id: productId,
        title: productData['title'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
        isFavorite: isFavorite,
      ));
    });

    notifyListeners();

    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    final response = await http.post(
      Uri.parse("$_baseUrl.json?auth=$_token"),
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        // 'isFavorite': newProduct.isFavorite,
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
        Uri.parse("$_baseUrl/${product.id}.json?auth=$_token"),
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

      final response =
          await http.delete(Uri.parse("$_baseUrl/${product.id}.json"));

      if (response.statusCode >= 400) {
        _items.insert(index, product);

        notifyListeners();
        throw const HttpException('Ocorreu um erro na exclusão do produto.');
      }
    }
  }
}
