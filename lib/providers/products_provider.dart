import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'mProduct.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _product = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._product];
  }

  List<Product> get favoriteItems {
    return _product.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _product.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProduct() async {
    const url = 'https://shop-6ebc7.firebaseio.com/prod.json';
    try {
      final res = await http.get(url);
      print(res.body);
    } catch (error) {
      print(error['source']);
      throw error;
    }
  }

  Future<void> addProduct(Product prod) async {
    const url = 'https://shop-6ebc7.firebaseio.com/prod.json';
    try {
      var res = await http.post(
        url,
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'imageUrl': prod.imageUrl,
          'price': prod.price,
          'isFavorite': prod.isFavorite,
        }),
      );
      final _newProd = Product(
        id: json.decode(res.body)['name'],
        title: prod.title,
        description: prod.description,
        price: prod.price,
        imageUrl: prod.imageUrl,
      );
      _product.add(_newProd);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void updateProduct(String id, Product newProd) {
    final prodIndex = _product.indexWhere((element) => element.id == id);

    if (prodIndex >= 0) {
      _product[prodIndex] = newProd;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _product.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}