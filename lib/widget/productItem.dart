import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

import '../providers/mProduct.dart';

class ProductItem extends StatelessWidget {
  // final Product product;
  // ProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<Product>(context, listen: false);
    final _cart = Provider.of<Cart>(context, listen: false);
    final _auth = Provider.of<Auth>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: _product.id,
            );
          },
          child: Hero(
            tag: _product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/loader.gif'),
              image: NetworkImage(
                _product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          title: Text(
            _product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (context, productobj, child) => IconButton(
              icon: Icon(
                _product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                _product.toggleFavorite(
                  _auth.token,
                  _auth.userId,
                );
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              _cart.addItem(
                _product.id,
                _product.title,
                _product.price,
              );
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item Added!'),
                  duration: Duration(seconds: 2),
                  elevation: 5,
                  backgroundColor: Theme.of(context).accentColor,
                  action: SnackBarAction(
                      textColor: Colors.black,
                      label: 'UNDO',
                      onPressed: () {
                        _cart.removeSingleItem(_product.id);
                      }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
