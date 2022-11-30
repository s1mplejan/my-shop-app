import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/auth.dart';
import 'package:mening_dokonim/providers/orders.dart';
import 'package:mening_dokonim/providers/products.dart';

import 'package:mening_dokonim/providers/cart.dart';
import 'package:mening_dokonim/screens/cart_screen.dart';
import 'package:mening_dokonim/screens/edit_product_screen.dart';
import 'package:mening_dokonim/screens/manage_products_screen.dart';
import 'package:mening_dokonim/screens/orders_screen.dart';
import 'package:provider/provider.dart';
import './screens/home_screen.dart';
import './styles/my_shop_style.dart';
import './screens/product_detailes_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  ThemeData theme = MyShopStyle.style;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(),
          update: (ctx, auth, previousProducts) =>
              previousProducts!..setParams(auth.token, auth.userId),
        ),
        ChangeNotifierProvider<Cart>(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (ctx, auth, previousOrders) =>
              previousOrders!..setParams(auth.token, auth.userId),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: authData.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: authData.autoLogin(),
                    builder: (c, autoLoginData) {
                      if (autoLoginData.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return const AuthScreen();
                      }
                    }),
            // initialRoute: HomeScreen.routeName,
            routes: {
              HomeScreen.routeName: (ctx) => HomeScreen(),
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              EditProductScreen.routeName: (ctx) => const EditProductScreen(),
              ManageProductsScreen.routeName: (ctx) =>
                  const ManageProductsScreen(),
            },
          );
        },
      ),
    );
  }
}
