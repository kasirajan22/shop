import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> product;
  final double amount;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.product,
    @required this.amount,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  final String authToken;
  final String userId;
  Order(this.authToken, this.userId, this._orders);
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getOrder() async {
    final url =
        'https://shop-6ebc7.firebaseio.com/orders.json?auth=$authToken';
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List<OrderItem> loadedOrders = [];
      final decodendRes = json.decode(res.body) as Map<String, dynamic>;
      decodendRes.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            product: (orderData['product'] as List<dynamic>)
                .map(
                  (val) => CartItem(
                      id: val['id'],
                      price: val['price'],
                      quanity: val['quantity'],
                      title: val['title']),
                )
                .toList(),
          ),
        );
        _orders = loadedOrders.reversed.toList();
        notifyListeners();
      });
    }
  }

  void addOrders(List<CartItem> cartProducts, double total) async {
    final url = 'https://shop-6ebc7.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timesamp = DateTime.now();
    final res = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timesamp.toIso8601String(),
        'product': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quanity,
                  'price': cp.price
                })
            .toList()
      }),
    );
    if (res.statusCode == 200) {
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(res.body)['name'],
          amount: total,
          dateTime: DateTime.now(),
          product: cartProducts,
        ),
      );
      notifyListeners();
    }
  }
}
