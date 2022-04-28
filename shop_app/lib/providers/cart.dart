import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get getCartItems {
    return {..._items};
  }

  int get numberOfCartItems {
    //if (_items.length == null) return 0;
    return _items.length;
  }

  double get totalAmount {
    double totalSum = 0.0;
    _items.forEach(
      (key, cartItem) {
        totalSum += cartItem.price * cartItem.quantity;
      },
    );
    return totalSum;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCardItem) => CartItem(
          id: existingCardItem.id,
          price: existingCardItem.price,
          title: existingCardItem.title,
          quantity: existingCardItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            price: price,
            quantity: 1,
            title: title),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (exisitingItem) => CartItem(
            id: exisitingItem.id,
            price: exisitingItem.price,
            quantity: exisitingItem.quantity - 1,
            title: exisitingItem.title),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
