import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/app_drawer.dart';
import '../widget/order_item.dart';
import '../providers/order.dart' show Order;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/order';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderItem(
          orders.orders[i],
        ),
        itemCount: orders.orders.length,
      ),
    );
  }
}
