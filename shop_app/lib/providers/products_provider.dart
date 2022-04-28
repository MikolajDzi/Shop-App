import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './product.dart';
import '../model/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  //var _showFavouritesOnly = false;

  List<Product> get getItems {
    // if (_showFavouritesOnly) {
    //   return _items.where((item) => item.isFavourite == true).toList();
    // }
    return [..._items];
  }

  List<Product> get getFavsItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Product findByID(String id) {
    return _items.firstWhere((product) => id == product.id);
  }

  // void toggleShowFavouritesOnly() {
  //   _showFavouritesOnly = !_showFavouritesOnly;
  //   notifyListeners();
  // }
  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
      'https://shop-app-tutorial-fe283-default-rtdb.europe-west1.firebasedatabase.app/products.json',
    );

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        _items = [];
        notifyListeners();
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, productData) {
        loadedProducts.add(Product(
          id: prodId,
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: double.parse(productData['price']),
          title: productData['title'],
          isFavourite: productData['isFavourite'],
        ));
      });
      //print(json.decode(response.body));
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
      'https://shop-app-tutorial-fe283-default-rtdb.europe-west1.firebasedatabase.app/products.json',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price.toString(),
          'imageUrl': product.imageUrl,
          'isFavourite': product.isFavourite,
        }),
      );
      final newProduct = Product(
        description: product.description,
        id: json.decode(response.body)['name'],
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
    //print(json.decode(response.body));

    //_items.insert(0, newProduct); //adds object at the beggining of the list
    //notifyListeners();
  }

  Future<void> upadateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((product) => product.id == id);

    if (prodIndex >= 0) {
      final url = Uri.parse(
        'https://shop-app-tutorial-fe283-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json',
      );
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price.toString(),
          'imageUrl': newProduct.imageUrl,
          'isFavourite': newProduct.isFavourite,
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      //print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
      'https://shop-app-tutorial-fe283-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json',
    );
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
    notifyListeners();
    //notifyListeners();
  }
}
