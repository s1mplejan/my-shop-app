import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/auth.dart';
import 'package:mening_dokonim/screens/home_screen.dart';
import 'package:mening_dokonim/screens/manage_products_screen.dart';
import 'package:mening_dokonim/screens/orders_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text('Salom do\'stim!'),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Magazin'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Buyurtmalar'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Mahsulotlarni boshqarish'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ManageProductsScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Chiqish'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
