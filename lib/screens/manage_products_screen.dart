import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/products.dart';
import 'package:mening_dokonim/screens/edit_product_screen.dart';
import 'package:mening_dokonim/widgets/app_drawer.dart';
import 'package:mening_dokonim/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  static const routeName = '/manage-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .getProductsFromFirebase(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productProvider = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mahsulotlarni boshqarish'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
              // .pushReplacementNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshotData) {
          if (snapshotData.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshotData.connectionState == ConnectionState.done) {
            return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Consumer<Products>(
                builder: (_, productProvider, child) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: productProvider.list.length,
                    itemBuilder: (ctx, i) {
                      final product = productProvider.list[i];
                      return ChangeNotifierProvider.value(
                        value: product,
                        child: const UserProductItem(),
                      );
                    },
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text('Xatolisk sodir bo\'ldi'),
            );
          }
        },
      ),
    );
  }
}
