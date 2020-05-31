import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quanity;

  CartItem({
    this.id,
    this.title,
    this.price,
    this.quanity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalAmount {
    double amount = 0.0;
    _items.forEach((key, value) {
      amount += value.quanity * value.price;
    });
    return amount;
  }

  int get getCount {
    return _items != null ? _items.length : 0;
  }

  void addItem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingRec) => CartItem(
          id: existingRec.id,
          title: existingRec.title,
          price: existingRec.price,
          quanity: existingRec.quanity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quanity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else if (_items[productId].quanity > 1) {
      _items.update(
        productId,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            price: value.price,
            quanity: value.quanity - 1),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
