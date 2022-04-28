import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widget/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      cart.totalAmount.toStringAsFixed(2),
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium
                              ?.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.numberOfCartItems,
              itemBuilder: (context, index) => CartItem(
                cart.getCartItems.values.toList()[index].id,
                cart.getCartItems.keys.toList()[index],
                cart.getCartItems.values.toList()[index].price,
                cart.getCartItems.values.toList()[index].quantity,
                cart.getCartItems.values.toList()[index].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(
                () {
                  _isLoading = true;
                },
              );
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.getCartItems.values.toList(),
                double.parse(widget.cart.totalAmount.toStringAsFixed(2)),
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
            },
      child:
          _isLoading ? const CircularProgressIndicator() : const Text("ORDER"),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
