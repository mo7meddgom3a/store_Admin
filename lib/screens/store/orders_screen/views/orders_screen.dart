import 'package:anwer_shop_admin/constants.dart';
import 'package:anwer_shop_admin/loader/loading_indicator.dart';
import 'package:anwer_shop_admin/screens/store/orders_screen/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anwer_shop_admin/screens/store/orders_screen/cubit/orders_cubit.dart';
import 'package:anwer_shop_admin/screens/store/orders_screen/cubit/orders_state.dart';
import '../../../dashboard/components/header.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().fetchAllUsersOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit()..fetchAllUsersOrders(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(
                  title: "الطلبات",
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'بحث عن طلب',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: BlocBuilder<OrdersCubit, OrdersState>(
                    builder: (context, state) {
                      if (state is OrdersLoaded) {
                        var filteredOrders = state.orders.where((order) =>
                        order.documentId.toLowerCase().contains(_searchQuery) ||
                            order.userId.toLowerCase().contains(_searchQuery) ||
                            order.status!.toLowerCase().contains(_searchQuery)).toList();

                        if (filteredOrders.isEmpty) {
                          return Center(
                            child: Text("لا توجد طلبات"),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: filteredOrders.length,
                            itemBuilder: (context, index) {
                              return OrderCardWidget(
                                order: filteredOrders[index],
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
      ),
    );
  }
}

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;

  const OrderCardWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    "رقم الطلب: ${order.documentId}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    tooltip: "تنزيل الطلب كملف PDF",
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                    ),
                    onPressed: () {
                      context.read<OrdersCubit>().downloadOrderAsPdf(context, order);
                    },
                    icon: Icon(
                      Icons.download,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              Text("تاريخ الطلب: ${order.orderDate}"),
              SizedBox(height: 8),
              Text("رقم المستخدم: ${order.userId}"),
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
                      "السعر: ${product['price']} ريال  سعودي | الكمية: ${product['productCount']}",
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text("عنوان الشحن"),
                subtitle: Text("${order.address}"),
                trailing: Column(
                  children: [
                    Text(
                      "رقم هاتف المستخدم:",
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
                  title: Text("ملاحظات"),
                  subtitle: Text("${order.notes}"),
                ),
              Divider(),
              ListTile(
                title: Text("الموقع على الخريطة"),
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
                      "حالة الطلب:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "${order.status}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: order.status == "تم التوصيل"
                              ? Colors.green
                              : order.status == "تم الإلغاء"
                              ? Colors.red
                              : Colors.blue),
                    ),
                  ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        "الإجمالي: ${order.totalPrice}",
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
                      context.read<OrdersCubit>().updateOrderStatus(order.documentId, "مقبول");
                    },
                    icon: Icon(Icons.check),
                    label: Text("قبول الطلب"),
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
                      context.read<OrdersCubit>().updateOrderStatus(order.documentId, "تم الإلغاء");
                    },
                    icon: Icon(Icons.cancel),
                    label: Text("إلغاء الطلب"),
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
                      context.read<OrdersCubit>().updateOrderStatus(order.documentId, "تم التوصيل");
                    },
                    icon: Icon(Icons.local_shipping),
                    label: Text("تم التوصيل"),
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
