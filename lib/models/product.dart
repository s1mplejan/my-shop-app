import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String discription;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.discription,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String? authToken, String? userId) async {
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        'https://my-first-frebase-app-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken');
    try {
      final response = await http.put(
        url,
        body: jsonEncode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 300 && response.statusCode < 200) {
        isFavorite = !isFavorite;
        notifyListeners();
      }
    } catch (e) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }
}
