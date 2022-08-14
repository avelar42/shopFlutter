import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;

  bool _showFavoriteOnly = false;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  void addProduct(Product product) {
    _items.add(product);
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
