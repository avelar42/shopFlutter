import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = [];
  final _baseurl =
      'https://shop-cod3r-d0b60-default-rtdb.firebaseio.com/products';

  bool _showFavoriteOnly = false;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  Future<void> addProduct(Product product) async {
    final response = await http.post(Uri.parse('$_baseurl.json'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        }));

    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
        id: id,
        name: product.name,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price));
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
        id: hasId ? data['id'] as String : Random().nextDouble().toString(),
        name: data['name'] as String,
        description: data['description'] as String,
        imageUrl: data['imageUrl'] as String,
        price: data['price'] as double);

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      await http.patch(Uri.parse('$_baseurl/${product.id}.json'),
          body: jsonEncode({
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          }));

      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(Uri.parse('$_baseurl.json'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          isFavorite: productData['isFavorite'],
        ),
      );
    });
    notifyListeners();
  }
}


// bool _showFavoriteOnly = false;

//   List<Product> get items {
//     if (_showFavoriteOnly) {
//       return _items.where((product) => product.isFavorite).toList();
//     } else {
//       return [..._items];
//     }
//   }

//   void showFavoriteOnly() {
//     _showFavoriteOnly = true;
//     notifyListeners();
//   }

//   void showallOnly() {
//     _showFavoriteOnly = false;
//     notifyListeners();
//   }
