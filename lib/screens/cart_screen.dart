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
                  OrderButton(cart: cart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _showLoader = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () {
              setState(() {
                _showLoader = true;
              });
              Provider.of<Order>(context, listen: false).addOrders(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              setState(() {
                _showLoader = false;
              });
              widget.cart.clearCart();
            },
      child: _showLoader ? CircularProgressIndicator() : Text('Order Now'),
    );
  }
}
