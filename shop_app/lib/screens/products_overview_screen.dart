import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:http/http.dart' as http;

import '../widget/products_grid.dart';
import '../widget/badge.dart';
import '../widget/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../screens/cart_screen.dart';

enum FilterOption {
  favourites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  //const ProductOverviewScreen({Key? key}) : super(key: key);
  var _showOnlyFavourites = false;
  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    //http.get(url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final productsContainter = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedOption) {
              setState(
                () {
                  if (selectedOption == FilterOption.favourites) {
                    //productsContainter.toggleShowFavouritesOnly();
                    _showOnlyFavourites = true;
                  } else if (selectedOption == FilterOption.all) {
                    //productsContainter.toggleShowFavouritesOnly();
                    _showOnlyFavourites = false;
                  }
                },
              );
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text("Only favourites."),
                value: FilterOption.favourites,
              ),
              const PopupMenuItem(
                child: Text("Show all."),
                value: FilterOption.all,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, iconButtonChild) => Badge(
              child: iconButtonChild as Widget,
              value: cart.numberOfCartItems.toString(),
              color: Theme.of(context).accentColor,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavourites),
    );
  }
}
