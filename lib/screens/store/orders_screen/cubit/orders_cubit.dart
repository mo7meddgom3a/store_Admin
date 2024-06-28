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

    // Load the logo image
    final logoImage = pw.MemoryImage(
      Uint8List.fromList(
        (await rootBundle.load('assets/images/pets.png')).buffer.asUint8List(),
      ),
    );

    // Load Arabic font
    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/IBMPlexSansArabic-Regular.ttf"),
    );

    pdf.addPage(pw.Page(
      pageFormat: pw_base.PdfPageFormat.a4,
      textDirection: pw.TextDirection.rtl, // Set text direction to RTL
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Image(logoImage, height: 50, width: 150),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('رقم الطلب: ${order.documentId}', style: pw.TextStyle(font: arabicFont)),
                pw.Text('تاريخ الطلب: ${order.orderDate}', style: pw.TextStyle(font: arabicFont)),
              ],
            ),
            pw.Divider(),
            pw.ListView.builder(
              itemCount: order.products.length,
              itemBuilder: (context, productIndex) {
                var product = order.products[productIndex];
                return pw.Row(
                  children: [
                    pw.Text("  - ${productIndex + 1}", style: pw.TextStyle(font: arabicFont)),
                    pw.Expanded(child: pw.Text(" ${product['name']}", style: pw.TextStyle(font: arabicFont))),
                    pw.Text(
                      "السعر : ${product['price']} ريال        |       الكمية : ${product['productCount']}",
                      style: pw.TextStyle(font: arabicFont),
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
                pw.Text("عنوان الشحن: ${order.address}", style: pw.TextStyle(font: arabicFont)),
                pw.SizedBox(height: 10),
                pw.Text("رقم هاتف المستخدم: ${order.contactNumber}", style: pw.TextStyle(font: arabicFont)),
              ],
            ),
            if (order.notes != null)
              pw.Text("ملاحظات: ${order.notes}", style: pw.TextStyle(font: arabicFont)),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.SizedBox(height: 5),
                    pw.Text(
                      "المبلغ الإجمالي: ${order.totalPrice} ريال",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: pw_base.PdfColors.blue,
                        font: arabicFont,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text(
                          "التوقيع: ..............",
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            font: arabicFont,
                          ),
                        ),
                      ],
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
  }}
