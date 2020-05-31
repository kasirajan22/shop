import 'package:flutter/foundation.dart';

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
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrders(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        product: cartProducts,
      ),      
    );
    notifyListeners();
  }
}
