import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/cart.dart';
import 'package:mening_dokonim/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/custom_cart.dart';
import 'cart_screen.dart';

enum FiltersOptions {
  Favorits,
  All,
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mening do'konim"),
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) {
              return const [
                PopupMenuItem(
                  value: FiltersOptions.All,
                  child: Text('Barchasi'),
                ),
                PopupMenuItem(
                  value: FiltersOptions.Favorits,
                  child: Text('Sevimli'),
                ),
              ];
            },
            onSelected: (FiltersOptions filter) {
              setState(() {
                if (filter == FiltersOptions.All) {
                  _showOnlyFavorites = false;
                } else {
                  _showOnlyFavorites = true;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) {
              return CustomCart(
                number: cart.itemsCount().toString(),
                child: child!,
              );
            },
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
