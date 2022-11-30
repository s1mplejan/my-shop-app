import 'package:flutter/material.dart';
import 'package:mening_dokonim/models/product.dart';
import 'package:mening_dokonim/providers/products.dart';
import 'package:mening_dokonim/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatefulWidget {
  final bool showFavorites;
  ProductsGrid(
    this.showFavorites, {
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  bool _init = true;
  bool _isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context, listen: false).getProductsFromFirebase();
    // });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).getProductsFromFirebase().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        widget.showFavorites ? productsData.favorites : productsData.list;

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : products.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20),
                itemCount: products.length,
                itemBuilder: (ctx, i) {
                  return ChangeNotifierProvider<Product>.value(
                    value: products[i],
                    child: ProductItem(),
                  );
                })
            : const Scaffold();
  }
}
