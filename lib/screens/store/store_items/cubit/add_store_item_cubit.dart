import 'dart:html';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
part 'add_store_item_state.dart';

class AddStoreItemCubit extends Cubit<AddStoreItemState> {
  AddStoreItemCubit() : super(AddStoreItemState());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController productCount = TextEditingController();

  String? categoryValue;
  bool? isRecommendedChecked = false;
  bool? isPopularChecked = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? image;
  XFile? pickedFile;
  Uint8List? bytes;

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
        emit(state.copyWith(images: imageBytesList));
      } else {
        emit(state.copyWith(images: null));
      }
    } catch (err) {
      print(err);
    }
  }

  void submitForm(BuildContext context) async {
    emit(state.copyWith(submission: Submission.loading));
    if (nameController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        state.images != null &&
        state.images!.isNotEmpty) {
      List<String> imageUrls = [];

      for (int i = 0; i < state.images!.length; i++) {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child('image_${i}_${DateTime.now().millisecondsSinceEpoch}.png');

        final UploadTask uploadTask = storageRef.putData(state.images![i]);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        final String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      await FirebaseFirestore.instance.collection('items').add({
        'name': nameController.text,
        'price': double.parse(priceController.text),
        'imageUrls': imageUrls,
        'description': descriptionController.text,
        'category': categoryValue,
        'productCount': double.parse(productCount.text),
        'isRecommended': isRecommendedChecked,
        'isPopular': isPopularChecked,
        'productID': '',
      });

      print("The download URLs are: $imageUrls");

      nameController.clear();
      priceController.clear();
      descriptionController.clear();
      productCount.clear();
      emit(state.copyWith(images: []));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
        ),
      );
      emit(state.copyWith(submission: Submission.success));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields and select at least one image'),
        ),
      );
      emit(state.copyWith(submission: Submission.failure));
    }
  }

  void updateToRecommended({required bool documentId}) async {
    isRecommendedChecked = documentId;
  }

  void updateToPopular({required bool documentId}) async {
    isPopularChecked = documentId;
  }
}
