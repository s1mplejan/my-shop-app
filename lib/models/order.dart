import 'package:mening_dokonim/models/cart_item.dart';

class Order {
  final String id;
  final double totalPrice;
  final DateTime date;
  final List<CartItem> products;

  Order({
    required this.id,
    required this.totalPrice,
    required this.date,
    required this.products,
  });
}
