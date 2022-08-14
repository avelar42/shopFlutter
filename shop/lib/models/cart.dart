import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
            id: existingItem.id,
            productId: existingItem.productId,
            name: existingItem.name,
            quatity: existingItem.quatity + 1,
            price: existingItem.price),
      );
    } else {
      _items.putIfAbsent(
          product.id,
          () => CartItem(
              id: Random().nextDouble().toString(),
              productId: product.id,
              name: product.name,
              quatity: 1,
              price: product.price));
    }
    notifyListeners();
  }

  void clearList() {
    _items = {};
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmout {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quatity;
    });
    return total;
  }
}
