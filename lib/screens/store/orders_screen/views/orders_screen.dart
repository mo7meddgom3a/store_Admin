
import 'package:anwer_shop_admin/screens/store/orders_screen/cubit/orders_cubit.dart';
import 'package:anwer_shop_admin/screens/store/orders_screen/cubit/orders_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants.dart';
import '../../../../loader/loading_indicator.dart';
import '../../../dashboard/components/header.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit()..fetchAllUsersOrders(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(
                title: "Orders",
              ),
              Divider(),
              Expanded(
                child: BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (context, state) {
                    if (state is OrdersLoaded) {
                      if (state.orders.isEmpty) {
                        return Center(
                          child: Text("No Orders Found"),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: state.orders.length,
                          itemBuilder: (context, index) {
                            return OrderCardWidget(
                              index: index,
                              state: state,
                            );
                          },
                        );
                      }
                    } else {
                      return Center(
                        child: loadingIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderCardWidget extends StatelessWidget {
  const OrderCardWidget({Key? key, required this.index, required this.state});

  final OrdersState state;
  final int index;

  @override
  Widget build(BuildContext context) {
    var order = state.orders[index];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order ID: ${order.documentId}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    tooltip: "Download Order as PDF",
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                    ),
                    onPressed: () {
                      context
                          .read<OrdersCubit>()
                          .downloadOrderAsPdf(context, order);
                    },
                    icon: Icon(
                      Icons.download,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              Text("Order Date: ${order.orderDate}"),
              SizedBox(height: 8),
              Text("User ID: ${order.userId}"),
              SizedBox(height: 8),
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: order.products.length,
                itemBuilder: (context, productIndex) {
                  var product = order.products[productIndex];
                  return ListTile(
                    title: Text("${product['name']}"),
                    subtitle: Text(
                      "Price: ${product['price']} EGP | Quantity: ${product['productCount']}",
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text("Shipping Address"),
                subtitle: Text("${order.address}"),
                trailing: Column(
                  children: [
                    Text(
                      "UserPhoneNumber:",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${order.contactNumber}",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (order.notes != null)
                ListTile(
                  title: Text("Notes"),
                  subtitle: Text("${order.notes}"),
                ),
              Divider(),
              ListTile(
                title: Text("Location on map"),
                subtitle: SelectableText(
                  order.mapLocation,
                  style: TextStyle(color: Colors.blue,),
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Text(
                      "Order Status:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "${order.status}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: order.status == "Delivered"
                              ? Colors.green
                              : order.status == "Canceled"
                              ? Colors.red
                              : Colors.blue),
                    ),
                  ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        "Total: ${order.totalPrice}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<OrdersCubit>()
                          .updateOrderStatus(order.documentId, "Accepted");
                    },
                    icon: Icon(Icons.check),
                    label: Text("Accept Order"),
                    style: ButtonStyle(
                      maximumSize: MediaQuery.of(context).size.width > 600
                          ? WidgetStateProperty.all(Size(200, 50))
                          : WidgetStateProperty.all(Size(150, 50)),
                      minimumSize: MediaQuery.of(context).size.width > 600
                          ? WidgetStateProperty.all(Size(200, 50))
                          : WidgetStateProperty.all(Size(150, 50)),
                      backgroundColor:
                      WidgetStateProperty.all(Colors.blue[900]),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<OrdersCubit>()
                          .updateOrderStatus(order.documentId, "Canceled");
                    },
                    icon: Icon(Icons.cancel),
                    label: Text("Cancel Order"),
                    style: ButtonStyle(
                      maximumSize: MediaQuery.of(context).size.width > 600
                          ? WidgetStateProperty.all(Size(200, 50))
                          : WidgetStateProperty.all(Size(150, 50)),
                      minimumSize: MediaQuery.of(context).size.width > 600
                          ? WidgetStateProperty.all(Size(200, 50))
                          : WidgetStateProperty.all(Size(150, 50)),
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<OrdersCubit>()
                          .updateOrderStatus(order.documentId, "Delivered");
                    },
                    icon: Icon(Icons.local_shipping),
                    label: Text("Delivered"),
                    style: ButtonStyle(
                      maximumSize: MediaQuery.of(context).size.width > 600
                          ? WidgetStateProperty.all(Size(200, 50))
                          : WidgetStateProperty.all(Size(150, 50)),
                      minimumSize: MediaQuery.of(context).size.width > 600
                          ? WidgetStateProperty.all(Size(200, 50))
                          : WidgetStateProperty.all(Size(150, 50)),
                      backgroundColor:
                      WidgetStateProperty.all(Colors.green[900]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
