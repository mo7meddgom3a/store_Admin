import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'store_state.dart';


class StoreCubit extends Cubit<StoreState> {
  StoreCubit() : super(StoreInitial());

  File? image;
  XFile? pickedFile;
  Uint8List? bytes;
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
        emit(StoreLoaded(items: storeItems , filteredItems: storeItems));
      });
      return Stream.empty();
    } catch (e) {
      emit(StoreError());
      return Stream.empty();
    }
  }

  void searchStoreItems(String query) {
    final currentState = state;
    if (currentState is StoreLoaded) {
      final filteredItems = currentState.items
          .where((item) =>
      item.name.toLowerCase().contains(query) ||
          item.category!.toLowerCase().contains(query) ?? false)
          .toList();
      emit(StoreLoaded(items: currentState.items, filteredItems: filteredItems));
    }
  }

  updateStoreItem(StoreItem item) async {
    try {
      List<String> imageUrls = [];

      if (state.image != null) {
        for (int i = 0; i < state.image!.length; i++) {
          final Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('product_images')
              .child('image_${i}_${DateTime.now().millisecondsSinceEpoch}.png');

          final UploadTask uploadTask = storageRef.putData(state.image![i]);
          TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
          final String imageUrl = await snapshot.ref.getDownloadURL();
          imageUrls.add(imageUrl);
        }
      } else {
        imageUrls = item.imageUrl;
        print(imageUrls);
      }

      // Update Firestore document with new item data and image URLs
      await FirebaseFirestore.instance
          .collection('items')
          .doc(item.documentId)
          .update({
        'name': item.name,
        'price': item.price,
        'category': categoryValue,
        'productCount': item.Quantity,
        'isRecommended': item.isRecommended,
        'isPopular': item.isPopular,
        'imageUrls': FieldValue.arrayUnion(imageUrls),
      });

    } catch (e) {
      emit(StoreError()); // Emit an error state or handle the error appropriately
    }
  }

  void deleteStoreItem(String documentId) {
    try {
      FirebaseFirestore.instance.collection('items').doc(documentId).delete();
    } catch (e) {
      emit(StoreError());
    }
  }

  removeImageFromFireStore(String documentId, String imageUrl) async {
    try {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      await FirebaseFirestore.instance.collection('items').doc(documentId).update({
        'imageUrls': FieldValue.arrayRemove([imageUrl])
      });
    } catch (e) {
      emit(StoreError());
    }
  }

  void uploadImages() async {
    try {
      final picker = ImagePicker();
      final List<XFile>? pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        List<Uint8List> imageBytesList = [];
        for (XFile file in pickedFiles) {
          Uint8List bytes = await file.readAsBytes();
          imageBytesList.add(bytes);
        }
        emit(state.copyWith(image: imageBytesList));
      } else {
        emit(state.copyWith(image: null));
      }
    } catch (err) {
      print(err);
    }
  }

  void removeImage(int index) {
    List<Uint8List> updatedImages = state.image!;
    updatedImages.removeAt(index);
    emit(state.copyWith(image: updatedImages));
  }
}