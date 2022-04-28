import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/app_drawer.dart';
import '../providers/orders.dart';
import '../widget/ordered_item.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders-screen';

  var _isLoading = false;
  @override
  // void initState() {
  //   _isLoading = true;
  //   Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your orders."),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                return const Center(
                  child: Text('Error occured.'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, ordersData, child) => ListView.builder(
                          itemCount: ordersData.getOrders.length,
                          itemBuilder: (context, index) => OrderedItem(
                            ordersData.getOrders[index],
                          ),
                        ));
              }
            }
          },
        )
        // _isLoading
        //     ? Center(child: CircularProgressIndicator())
        //     : ListView.builder(
        //         itemCount: ordersData.getOrders.length,
        //         itemBuilder: (context, index) => OrderedItem(
        //           ordersData.getOrders[index],
        //         ),
        //       ),
        );
  }
}
