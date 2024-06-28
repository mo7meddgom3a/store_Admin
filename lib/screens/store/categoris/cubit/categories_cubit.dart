import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:anwer_shop_admin/screens/store/categoris/cubit/categories_state.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  StreamSubscription? _categoriesSubscription; // Declare a StreamSubscription

  CategoriesCubit() : super(CategoriesInitial());

  File? image;
  XFile? pickedFile;
  Uint8List? bytes;

  void loadCategoriesItems() {
    emit(CategoriesLoading());
    try {
      final snapshot = FirebaseFirestore.instance.collection('storeCategories').snapshots();
      _categoriesSubscription = snapshot.listen((event) {
        final storeItems = event.docs.map((doc) {
          final data = doc.data();
          return CategoriesItem(
            imageUrl: data['imageUrl'] ?? "",
            category: data['name'] ?? "",
            documentId: doc.id,
          );
        }).toList();
        emit(CategoriesLoaded(items: storeItems));
      });
    } catch (e) {
      emit(CategoriesError());
    }
  }

  void closeCategoriesStream() {
    _categoriesSubscription?.cancel();
  }

  loadCategoriesNames() async {
    emit(CategoriesLoading());
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('storeCategories').get();
      final categoryNames = snapshot.docs
          .map((doc) {
        final data = doc.data();
        return data['name'] ?? "";
      })
          .toList()
          .cast<String>();
      emit(CategoriesNamesLoaded(items: categoryNames));
    } catch (e) {
      emit(CategoriesError());
    }
  }

   uploadImage() async {
    try {
      final picker = ImagePicker();
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        bytes = await pickedFile!.readAsBytes();
        emit(state.copyWith(image: bytes));
      } else {
        emit(state.copyWith(image: null));
      }
    } catch (err) {
      print(err);
    }
  }

  updateCategoryItem(CategoriesItem item) async {
    try {
    if (state.image != null) {

      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child(pickedFile!.path);
      final UploadTask uploadTask = storageRef.putData(state.image!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {
      });
      final String imageUrl = await snapshot.ref.getDownloadURL();


      FirebaseFirestore.instance
          .collection('storeCategories')
          .doc(item.documentId)
          .update({
        'name': item.category,
        'imageUrl': imageUrl,
      });
      emit(state.copyWith(image: Uint8List(0)));

    }
    } catch (e) {
      emit(CategoriesError());
    }
  }

  void deleteCategoryItem(String documentId) {
    try {
      FirebaseFirestore.instance
          .collection('storeCategories')
          .doc(documentId)
          .delete();
    } catch (e) {
      emit(CategoriesError());
    }
  }
  void removeImage() {
    Uint8List updatedImages = state.image!;
    updatedImages = Uint8List.fromList([]);
    emit(state.copyWith(image: updatedImages));
  }
}
