import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/edit_product_screen.dart';

import './providers/products_provider.dart';
import './screens/product_overview_screen.dart';
import './data/theme.dart';
import 'providers/cart.dart';
import 'providers/order.dart';
import 'screens/cart_screen.dart';
import 'screens/orderScreen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/user_product_screen.dart';

void main() {
  runApp(MyApp());
}
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final FirebaseApp app = await FirebaseApp.configure(
//     name: 'shop',
//     options: const FirebaseOptions(
//       googleAppID: '1:652552947559:android:44ce2ea943c288bcc591c2',
//       apiKey: 'AIzaSyB0DZlYJEdo4ta-mktiXI5TKKmvjEvsO44',
//       databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
//     ),
//   );
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: myTheme,
        //home: ProductOverviewScreen(),
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (ctx) => ProductOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen()
        },
      ),
    );
  }
}
