import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import '../widget/app_drawer.dart';
import '../providers/cart.dart';
import '../widget/product_grid.dart';
import 'cart_screen.dart';

enum FilterOptions { Filtered, All }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _sowFilteredproduct = false;

  @override
  void initState() {
    Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorite'), value: FilterOptions.Filtered),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ],
            onSelected: (FilterOptions val) {
              setState(() {
                if (val == FilterOptions.Filtered) {
                  _sowFilteredproduct = true;
                } else {
                  _sowFilteredproduct = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (ctx, cart, _) => GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              child: Badge(
                position: BadgePosition.bottomLeft(bottom: 30, left: 10),
                badgeColor: Theme.of(context).accentColor,
                child: Icon(Icons.shopping_cart),
                badgeContent: Text(
                  cart.getCount?.toString(),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGrid(_sowFilteredproduct),
    );
  }
}
