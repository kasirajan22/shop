import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/mProduct.dart';
import '../widget/app_drawer.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFN = FocusNode();
  final _descriptionFN = FocusNode();
  final _imageUrl = TextEditingController();
  final _imageUrlFN = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _showLoader = false;
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initVal = {
    'id': '',
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  bool isFirst = true;
  @override
  void initState() {
    _imageUrlFN.addListener(_upateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isFirst) {
      String productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<ProductsProvider>(context).findById(productId);
        _initVal = {
          'id': _editedProduct.id,
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrl.text = _editedProduct.imageUrl;
      }
    }
    isFirst = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _priceFN.dispose();
    // _descriptionFN.dispose();
    // _imageUrl.dispose();
    // _imageUrlFN.dispose();
    // _imageUrlFN.removeListener(_upateImageUrl);
    super.dispose();
  }

  void _upateImageUrl() {
    if (!_imageUrlFN.hasFocus) {
      setState(() {});
    }
  }

  void _submitForm() async {
    _form.currentState.save();
    setState(() {
      _showLoader = true;
    });
    if (_editedProduct.id == null) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Error'),
                  content: Text(error.toString()),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
      // finally {
      //   setState(() {
      //     _showLoader = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    } else {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    }
    setState(() {
      _showLoader = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _submitForm(),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _showLoader
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                        initialValue: _initVal['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_priceFN),
                        onSaved: (val) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: val,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                          );
                        }),
                    TextFormField(
                      initialValue: _initVal['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFN,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_descriptionFN),
                      onSaved: (val) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(val),
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initVal['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      focusNode: _descriptionFN,
                      onSaved: (val) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: val,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 12),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrl.text.isEmpty
                              ? Text('Enter URL')
                              : Image.network(_imageUrl.text,
                                  fit: BoxFit.cover),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            controller: _imageUrl,
                            focusNode: _imageUrlFN,
                            onSaved: (val) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: val,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
