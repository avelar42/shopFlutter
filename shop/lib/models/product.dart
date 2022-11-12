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

  Future<void> toggleFavorite(String token, String userId) async {
    try {
      _toogleFavorite();

      final response = await http.put(
          Uri.parse(
              '${Constants.USER_FAVORITE_URL}/$userId/$id.json?auth=$token'),
          body: jsonEncode(isFavorite));

      if (response.statusCode >= 400) {
        _toogleFavorite();
      }
    } catch (error) {
      print(error);
      _toogleFavorite();
    }
  }
}
