import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/cart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartListItem extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String title;
  final double price;
  final int quantity;
  const CartListItem({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
  });

  void _notifyUserAboutDelete(BuildContext context, Function() removeItem) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Ishonchingiz komilmi?'),
          content: const Text('Savatchadan bu mahsulotni o\'chmoqda!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Bekor qilish'),
            ),
            ElevatedButton(
              onPressed: () {
                removeItem();
                Navigator.of(context).pop();
              },
              child: const Text('O\'chirish'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).errorColor,
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Slidable(
      key: ValueKey(productId),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          ElevatedButton(
            onPressed: () => _notifyUserAboutDelete(
              context,
              () => cart.removeItem(productId),
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).errorColor,
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
            ),
            child: const Text('O\'chirish'),
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          subtitle: Text('Umumiy \$${(price * quantity).toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                splashRadius: 20,
                onPressed: () => cart.removeSingleItem(productId),
                icon: const Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100,
                ),
                child: Text(
                  '$quantity',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                splashRadius: 20,
                onPressed: () => cart.addToCart(
                  productId,
                  title,
                  imageUrl,
                  price,
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
