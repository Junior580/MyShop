import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toogleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toogleFavorite(String? token, String? userId) async {
    _toogleFavorite();

    try {
      final String url =
          '${Constants.BASE_API_URL}/userFavorites/$userId/$id.json?auth=$token';
      final response =
          await http.put(Uri.parse(url), body: json.encode(isFavorite));

      if (response.statusCode >= 400) {
        _toogleFavorite();
      }
    } catch (error) {
      _toogleFavorite();
    }
  }
}
