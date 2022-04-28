import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double finalAmount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.finalAmount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
      'https://shop-app-tutorial-fe283-default-rtdb.europe-west1.firebasedatabase.app/orders.json',
    );
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        _orders = [];
        notifyListeners();
        return;
      }
      final List<OrderItem> loadedOrders = [];

      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          finalAmount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title']),
              )
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
      'https://shop-app-tutorial-fe283-default-rtdb.europe-west1.firebasedatabase.app/orders.json',
    );
    // _orders.insert(
    //   0,
    //   OrderItem(
    //     id: DateTime.now().toString(),
    //     finalAmount: total,
    //     products: cartProducts,
    //     dateTime: DateTime.now(),
    //   ),
    // );
    final timeStamp = DateTime.now();

    notifyListeners();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map(
                (cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                },
              )
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          finalAmount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ),
      );
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }
}
