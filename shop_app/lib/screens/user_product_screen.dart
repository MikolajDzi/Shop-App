import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../screens/manage_product_screens.dart';
import '../widget/user_product_item.dart';
import '../widget/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-screen';
  //const UserProductScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your products.'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ManageProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _refreshProducts(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.getItems.length,
            itemBuilder: (_, index) => Column(
              children: [
                UserProductItem(
                  id: productsData.getItems[index].id,
                  imageUrl: productsData.getItems[index].imageUrl,
                  title: productsData.getItems[index].title,
                ),
                //const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
