import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class Cartitem extends StatelessWidget {
  final CartItem item;
  final String productId;
  Cartitem(this.item, this.productId);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove item from cart?'),
            elevation: 5,            
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      key: ValueKey(item.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text('₹ ${item.price}'),
              ),
            ),
          ),
          title: Text('${item.title}'),
          subtitle: Text('${(item.price * item.quanity)}'),
          trailing: Text('${item.quanity} x'),
        ),
      ),
    );
  }
}
