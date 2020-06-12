import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<ProductsProvider>(context).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     loadedProduct.title,
      //   ),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProduct.title,
              ),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Price : ${loadedProduct.price}',
                  style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${loadedProduct.description}',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 900,
                ),
              ],
            ),
          ),
        ],
        // child: Column(
        //   children: <Widget>[
        //     Container(
        //       child: ,
        //       height: 300,
        //       width: double.infinity,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
