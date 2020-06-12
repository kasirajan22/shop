import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';
import '../providers/order.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {


  var _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    //final orderItem = Provider.of<oi.OrderItem>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds:300),
      height: _isExpanded ? min(widget.order.product.length * 50.0 + 150, 220) : 95,
          child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('₹ ${widget.order.amount.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.title),
              subtitle: Text(
                DateFormat('dd-MM-yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
            //if (_isExpanded)
              AnimatedContainer(
                duration: Duration(milliseconds:300),    
                curve: Curves.bounceOut,            
                  padding: EdgeInsets.all(20),
                  height: _isExpanded ? min(widget.order.product.length * 70.0 + 10, 100) : 0,
                  child: ListView(
                      children: widget.order.product
                          .map(
                            (e) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(e.title,
                                    style: Theme.of(context).textTheme.title),
                                Text('${e.price} x ${e.quanity}'),
                              ],
                            ),
                          )
                          .toList()))
          ],
        ),
      ),
    );
  }
}
