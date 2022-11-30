import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/orders.dart';
import 'package:mening_dokonim/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Buyurtmalar'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orders.items.length,
        itemBuilder: ((context, index) {
          final order = orders.items[index];
          return OrderItem(
            totalPrice: order.totalPrice,
            date: order.date,
            products: order.products,
          );
        }),
      ),
    );
  }
}
