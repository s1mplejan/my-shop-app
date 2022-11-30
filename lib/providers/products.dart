import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _list = [
    // Product(
    //   id: "p1",
    //   title: "Macbook pro",
    //   discription: "Ajoyib macbook pro",
    //   price: 1200,
    //   imageUrl:
    //       "https://www.notebookcheck.net/fileadmin/Notebooks/News/_nc3/photo_1517336714731_489689fd1ca8_9.jpeg",
    // ),
    // Product(
    //   id: "p2",
    //   title: "iPhone 13",
    //   discription:
    //       "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32.The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham. Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32.The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham. ",
    //   price: 1450,
    //   imageUrl:
    //       "https://i.insider.com/617ad55a46a50c0018d40cc9?width=1136&format=jpeg",
    // ),
    // Product(
    //   id: "p3",
    //   title: "Apple Watch",
    //   discription: "O'zgacha va qulay - xuddi siz xoxlagandek!",
    //   price: 450.5,
    //   imageUrl:
    //       "https://www.apple.com/v/watch/at/images/meta/gps-lte/og__n5qzveqr596m.png",
    // ),
  ];

  String? _authToken;
  String? _userId;

  void setParams(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  List<Product> get list {
    return [..._list];
  }

  List<Product> get favorites {
    return _list.where((element) => element.isFavorite).toList();
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final productIndex = _list.indexWhere(
      (element) => element.id == updatedProduct.id,
    );

    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://my-first-frebase-app-default-rtdb.firebaseio.com/products/${updatedProduct.id}.json?auth=$_authToken');

      try {
        await http.patch(
          url,
          body: jsonEncode(
            {
              'title': updatedProduct.title,
              'discription': updatedProduct.discription,
              'price': updatedProduct.price,
              'imageUrl': updatedProduct.imageUrl,
            },
          ),
        );
      } catch (e) {
        rethrow;
      }

      _list[productIndex] = updatedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://my-first-frebase-app-default-rtdb.firebaseio.com/products/${id}.json?auth=$_authToken');

    try {
      await http.delete(url);
      _list.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getProductsFromFirebase([bool filterByUser = false]) async {
   final filterString = filterByUser ? '&orderBy="creatorId"&equalTo="$_userId"' : ''; 
    final url = Uri.parse(
        'https://my-first-frebase-app-default-rtdb.firebaseio.com/products.json?auth=$_authToken$filterString');

    try {
      final response = await http.get(url);
      if (jsonDecode(response.body) != null) {
        final favoriteUrl = Uri.parse(
            'https://my-first-frebase-app-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken');

        final favoriteResponse = await http.get(favoriteUrl);
        final favoriteData = jsonDecode(favoriteResponse.body);

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        data.forEach((key, value) {
          loadedProducts.add(
            Product(
              id: key,
              title: value['title'],
              discription: value['discription'],
              price: value['price'],
              imageUrl: value['imageUrl'],
              isFavorite: favoriteData == null || favoriteData[key] == null
                  ? false
                  : favoriteData[key],
            ),
          );
          _list = loadedProducts;
          notifyListeners();
        });
      }
    } catch (e) {
      // rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://my-first-frebase-app-default-rtdb.firebaseio.com/products.json?auth=$_authToken');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'title': product.title,
          'price': product.price,
          'discription': product.discription,
          'imageUrl': product.imageUrl,
          'creatorId': _userId,
        }),
      );
      //.then((response) {
      final id = (jsonDecode(response.body) as Map<String, dynamic>)['name'];
      final newProduct = Product(
        id: id,
        title: product.title,
        discription: product.discription,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _list.add(newProduct);

      notifyListeners();
    } catch (error) {
      throw error;
    }

    // }).catchError((error) {
    //   throw error;
    // });
  }

  Product findByID(String productId) {
    return _list.firstWhere((element) => element.id == productId);
  }
}
