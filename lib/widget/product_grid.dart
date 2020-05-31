import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widget/productItem.dart';

class ProductGrid extends StatelessWidget {
  final showFavorite;
  ProductGrid(this.showFavorite);
  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<ProductsProvider>(context);
    final loadedProducts = showFavorite ? prod.favoriteItems : prod.items;
    return GridView.builder(
      padding: EdgeInsets.all(15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i],
        child: ProductItem(
            //loadedProducts[i],
            ),
      ),
      itemCount: loadedProducts.length,
    );
  }
}
