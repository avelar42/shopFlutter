import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  void _toogleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    try {
      _toogleFavorite();

      final response =
          await http.patch(Uri.parse('${Constants.PRODUCT_BASE_URL}/$id.json'),
              body: jsonEncode({
                "isFavorite": isFavorite,
              }));

      if (response.statusCode >= 400) {
        _toogleFavorite();
      }
    } catch (error) {
      _toogleFavorite();
    }
  }
}
