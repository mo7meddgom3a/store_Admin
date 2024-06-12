import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'store_state.dart';


class StoreCubit extends Cubit<StoreState> {
  StoreCubit() : super(StoreInitial());

  // File? image;
  // XFile? pickedFile;
  // Uint8List? bytes;
  String? categoryValue ;

  Stream loadStoreItems() {
    emit(StoreLoading());
    try {
      final snapshot =
      FirebaseFirestore.instance.collection('items').snapshots();
      snapshot.listen((event) {
        final storeItems = event.docs.map((doc) {
          final data = doc.data();
          return StoreItem(
            documentId: doc.id,
            imageUrl: List<String>.from(data['imageUrls'] ?? []),
            name: data['name'] ?? "",
            price: data['price'] ?? "",
            category: data['category'] ?? "",
            Quantity: data['productCount'] ?? "",
          );
        }).toList();
        emit(StoreLoaded(items: storeItems));
      });
      return Stream.empty();
    } catch (e) {
      emit(StoreError());
      return Stream.empty();
    }
  }

  // void uploadImage() async {
  //   try {
  //     final picker = ImagePicker();
  //     pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       bytes = await pickedFile!.readAsBytes();
  //       emit(state.copyWith(image: bytes));
  //     } else {
  //       emit(state.copyWith(image: null));
  //     }
  //   } catch (err) {
  //     print(err);
  //   }}

  void updateStoreItem(StoreItem item) async{
    try {

      FirebaseFirestore.instance
          .collection('items')
          .doc(item.documentId)
          .update({
        'name': item.name,
        'price': item.price,
        'category': categoryValue,
        'productCount': item.Quantity,
        "isRecommended": item.isRecommended,
        "isPopular": item.isPopular,
      });
    } catch (e) {
      emit(StoreError());
    }
  }

  void deleteStoreItem(String documentId) {
    try {
      FirebaseFirestore.instance.collection('items').doc(documentId).delete();
    } catch (e) {
      emit(StoreError());
    }
  }
}