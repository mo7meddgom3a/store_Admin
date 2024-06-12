import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

final class OrderModel extends Equatable {
  final String documentId; // Updated
  final double? totalPrice;
  final String? contactNumber;
  final String? address;
  final String? status;
  final List products;
  final String? orderDate;
  final String? notes;
  final bool isAccepted;
  final bool isDelivered;
  final bool isCanceled;

  final String userId;
  final String mapLocation;

  OrderModel({
    required this.userId,
    required this.isCanceled,
    required this.isAccepted,
    required this.isDelivered,
    required this.totalPrice,
    required this.contactNumber,
    required this.address,
    required this.status,
    required this.products,
    required this.orderDate,
    required this.documentId, // Updated
    required this.notes,
    required this.mapLocation,
  });


  OrderModel copyWith({
    String? documentId,
    double? totalPrice,
    String? contactNumber,
    String? address,
    String? status,
    List? products,
    String? orderDate,
    bool? isAccepted,
    bool? isDelivered,
    bool? isCanceled,
    String? notes,
    String? mapLocation,
  }) {
    return OrderModel(
      userId: userId,
      isCanceled: isCanceled ?? this.isCanceled,
      documentId: documentId ?? this.documentId,
      totalPrice: totalPrice ?? this.totalPrice,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      status: status ?? this.status,
      products: products ?? this.products,
      orderDate: orderDate ?? this.orderDate,
      isAccepted: isAccepted ?? this.isAccepted,
      isDelivered: isDelivered ?? this.isDelivered,
      notes: notes ?? this.notes,
      mapLocation: mapLocation ?? this.mapLocation,
    );
  }

  Map<String , dynamic> toMap(){
    return {
      'documentId': documentId,
      'totalPrice': totalPrice,
      'contactNumber': contactNumber,
      'address': address,
      'status': status,
      'products': products,
      'orderDate': orderDate,
      'isAccepted': isAccepted,
      'isDelivered': isDelivered,
      'isCanceled': isCanceled,
      'notes': notes ?? '',
      'maplocation': mapLocation,
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot){
    return OrderModel(
      mapLocation: snapshot['maplocation'] ?? "",
      userId: snapshot['User'],
      isCanceled: snapshot['isCanceled'],
      documentId: snapshot['documentId'],
      totalPrice: snapshot['totalPrice'],
      contactNumber: snapshot['contactNumber'],
      address: snapshot['address'],
      status: snapshot['status'],
      products: snapshot['products'],
      orderDate: snapshot['orderDate'],
      isAccepted: snapshot['isAccepted'],
      isDelivered: snapshot['isDelivered'],
      notes: snapshot['notes'],
    );
  }

  String toJson() => json.encode(toMap());

  bool get stringify => true;
  @override
  List<Object?> get props => [
    documentId,
    totalPrice,
    contactNumber,
    address,
    status,
    products,
    orderDate,
    isAccepted,
    isDelivered,
    notes,
  ];
}
