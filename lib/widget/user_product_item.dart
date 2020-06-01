import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({this.id, this.title, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Card(
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(title, style: Theme.of(context).textTheme.title),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName, arguments: id);
                  }),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text('Do you want to remove this product?'),
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
                            onPressed: () async {
                              try {
                                await Provider.of<ProductsProvider>(ctx,
                                        listen: false)
                                    .deleteProduct(id);
                              } catch (error) {
                                scaffold.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      error.message.toString(),
                                    ),
                                  ),
                                );
                              } finally {
                                Navigator.of(ctx).pop(true);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
