import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/cart.dart';
import 'package:mening_dokonim/providers/orders.dart';
import 'package:mening_dokonim/widgets/cart_list_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sizning savatchangiz'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Umumiy:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(
                        context,
                        listen: false,
                      ).addToOrders(
                        cart.items.values.toList(),
                        cart.totalPrice,
                      );
                      cart.clearCart();
                    },
                    child: const Text('Buyurtma berish'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount(),
              itemBuilder: (context, index) {
                final cartItem = cart.items.values.toList()[index];
                return CartListItem(
                  productId: cart.items.keys.toList()[index],
                  imageUrl: cartItem.image,
                  title: cartItem.title,
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
