import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';

import '../utils/constants.dart';

class OrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  OrderList([this._token = '', this._userId = '', this._items = const []]);

  Future<void> loadOrders() async {
    List<Order> items = [];
    final response = await http.get(
        Uri.parse('${Constants.ORDER_BASE_URL}/$_userId.json?auth=$_token'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    //print(data);
    data.forEach((orderId, orderData) {
      items.add(
        Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
                id: item['id'],
                productId: item['productId'],
                name: item['name'],
                quatity: item['quatity'],
                price: item['price']);
          }).toList(),
          //       price: productData['price'],
          //       isFavorite: productData['isFavorite'],
        ),
      );
    });
    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
        Uri.parse('${Constants.ORDER_BASE_URL}/$_userId.json?auth=$_token'),
        body: jsonEncode({
          'total': cart.totalAmout,
          'date': date.toIso8601String(),
          'products': cart.items.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'name': cartItem.name,
                    'quatity': cartItem.quatity,
                    'price': cartItem.price
                  })
              .toList(),
        }));

    final id = jsonDecode(response.body)['name'];

    _items.insert(
        0,
        Order(
            id: id,
            total: cart.totalAmout,
            products: cart.items.values.toList(),
            date: date));
    notifyListeners();
  }
}
