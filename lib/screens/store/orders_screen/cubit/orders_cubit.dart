import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pw_base;
import 'orders_state.dart';
import '../models/order_model.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersState([]));

  Stream<List<OrderModel>> fetchAllUsersOrders() {
    try {
      emit(OrdersLoading([]));
      final stream = FirebaseFirestore.instance
          .collection('Orders')
          .orderBy('orderDate', descending: true)
          .snapshots();
      stream.listen((event) {
        final orders = event.docs.map((doc) {
          final data = doc.data();
          return OrderModel(
            userId: data['User'] ?? "",
            documentId: doc.id,
            totalPrice: double.tryParse(data['totalPrice'].toString()) ?? 0.0,
            contactNumber: data['contactNumber'] ?? "",
            address: data['location'] ?? "",
            status: data['status'] ?? "",
            products: List<Map<String, dynamic>>.from(data['products'] ?? []),
            orderDate: _formatDate(data['orderDate']),
            isAccepted: data['isAccepted'] ?? false,
            isDelivered: data['isDelivered'] ?? false,
            isCanceled: data['isCanceled'] ?? false,
            notes: data['notes'] ?? "",
            mapLocation: data['maplocation'] ?? "",
          );
        }).toList();
        emit(OrdersLoaded(orders));
      });
      return Stream.empty();
    } catch (e) {
      return Stream.empty();
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return "";
    try {
      final parsedDate = DateTime.parse(date.toString());
      final formattedDate = "${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.year}";
      final formattedTime = "${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}:${parsedDate.second.toString().padLeft(2, '0')}";
      return "$formattedDate $formattedTime";
    } catch (e) {
      print('Error parsing date: $e');
      return "";
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('Orders').doc(orderId).update({'status': newStatus});
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  Future<void> downloadOrderAsPdf(BuildContext context, OrderModel order) async {
    final pdf = pw.Document();
    final logoImage = pw.MemoryImage(
      Uint8List.fromList(
        (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
      ),
    );

    pdf.addPage(pw.Page(
      pageFormat: pw_base.PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Center(
              child: pw.Image(logoImage, height: 50, width: 150),),
            pw.SizedBox(height: 20),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Order ID: ${order.documentId}'),
                pw.Text('Order Date: ${order.orderDate}'),
              ],
            ),
            pw.Divider(),
            pw.ListView.builder(
              itemCount: order.products.length,
              itemBuilder: (context, productIndex) {
                var product = order.products[productIndex];
                return pw.Row(
                  children: [
                    pw.Text(" ${productIndex + 1} - "),
                    pw.Expanded(child: pw.Text(" ${product['name']}")),
                    pw.Text(
                      "Price: ${product['price']} EGP | Quantity: ${product['productCount']}",
                    ),
                  ],
                );
              },
            ),
            pw.Divider(),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text("Shipping Address: ${order.address}"),
                pw.SizedBox(height: 10),
                pw.Text("UserPhoneNumber: ${order.contactNumber}"),
              ],
            ),

            if(order.notes != null)
              pw.Text("Notes: ${order.notes}") ,
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.SizedBox(height: 5),
                    pw.Text(
                      "TotalPrice: ${order.totalPrice} EGP",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: pw_base.PdfColors.blue,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children:[
                          pw.Text(
                            "Signature: ..............",
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ]
                    )
                  ],
                ),
              ],
            ),
          ],
        );
      },
    ));

    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'order_${order.documentId}.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
