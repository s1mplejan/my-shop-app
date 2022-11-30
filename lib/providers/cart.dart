import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int itemsCount() {
    return _items.length;
  }

  double get totalPrice {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addToCart(
    String productId,
    String title,
    String image,
    double price,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            quantity: value.quantity + 1,
            price: value.price,
            image: value.image),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: UniqueKey().toString(),
          title: title,
          quantity: 1,
          price: price,
          image: image,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId, {bool isCartButton = false}) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (value) => CartItem(
          id: productId,
          title: value.title,
          quantity: value.quantity - 1,
          price: value.price,
          image: value.image,
        ),
      );
      notifyListeners();
    } else if (isCartButton) {
      _items.remove(productId);
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((key, value) => key == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
