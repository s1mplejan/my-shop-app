import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/cart.dart';
import 'package:mening_dokonim/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  ProductDetailsScreen({
    super.key,
  });
  static const routeName = '/product_details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments.toString();
    final product =
        Provider.of<Products>(context, listen: false).findByID(productId);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(product.discription),
            ),
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Narxi: ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Consumer<Cart>(
                builder: (context, value, child) {
                  final isProductAdded = value.items.containsKey(productId);
                  if (isProductAdded) {
                    return ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(CartScreen.routeName),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                        primary: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 15,
                        color: Colors.black,
                      ),
                      label: const Text(
                        'Savatchaga borish',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () => value.addToCart(
                        productId,
                        product.title,
                        product.imageUrl,
                        product.price,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Savatchaga qo\'shish'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
