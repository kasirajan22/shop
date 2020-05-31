import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';
import '../providers/cart.dart';
import '../widget/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Shpping Cart',
          ),
        ),
        body: Column(
          children: <Widget>[
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(width: 10),
                  Text('Total', style: Theme.of(context).textTheme.title),
                  Spacer(),
                  Chip(
                    label: Text(
                      '₹ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Order>(context, listen: false).addOrders(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.clearCart();
                    },
                    child: Text('Order Now'),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, i) => Cartitem(
                  cart.items.values.toList()[i],
                  cart.items.keys.toList()[i],
                ),
                itemCount: cart.getCount,
              ),
            ),
          ],
        ));
  }
}
