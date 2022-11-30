import 'package:flutter/material.dart';
import 'package:mening_dokonim/models/product.dart';
import 'package:mening_dokonim/providers/auth.dart';
import 'package:mening_dokonim/providers/cart.dart';
import 'package:mening_dokonim/screens/product_detailes_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  ProductItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {
              product.toggleFavorite(auth.token, auth.userId);
            },
            icon: Consumer<Product>(
              builder: (ctx, prod, child) {
                return Icon(
                  product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_outline_outlined,
                  color: Theme.of(context).primaryColor,
                );
              },
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addToCart(
                product.id,
                product.title,
                product.imageUrl,
                product.price,
              );
              // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              // ScaffoldMessenger.of(context).showMaterialBanner(
              //   MaterialBanner(
              //     content: const Text('Savatchaga qo\'shildi!'),
              //     actions: [
              //       TextButton(
              //         onPressed: () {
              //           cart.removeSingleItem(
              //             product.id,
              //             isCartButton: true,
              //           );
              //           ScaffoldMessenger.of(context)
              //               .hideCurrentMaterialBanner();
              //         },
              //         child: const Text('Bekor qilish'),
              //       ),
              //     ],
              //   ),
              // );
              // Future.delayed(
              //   const Duration(seconds: 2),
              // ).then(
              //   (value) =>
              //       ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              // );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Savatchaga qo\'shildi!'),
                  duration: const Duration(
                    seconds: 2,
                  ),
                  action: SnackBarAction(
                    label: 'Bekor qilish',
                    onPressed: () {
                      cart.removeSingleItem(
                        product.id,
                        isCartButton: true,
                      );
                    },
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: (() {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          }),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
