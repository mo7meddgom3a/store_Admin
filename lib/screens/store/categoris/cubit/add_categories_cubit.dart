import 'dart:html';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_categories_state.dart';

class AddCategoriesItemCubit extends Cubit<AddCategoriesItemState> {
  AddCategoriesItemCubit() : super(AddCategoriesItemState());
  final TextEditingController CategoryController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? image;
  XFile? pickedFile;
  Uint8List? bytes;

  void uploadImage() async {
    try {
      final picker = ImagePicker();
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        bytes = await pickedFile!.readAsBytes();
        // bytes = await image!.readAsBytes();
        // print(bytes);
        emit(state.copyWith(image: bytes,submission: Submission.editing));
      } else {
        emit(state.copyWith(image: null,submission: Submission.editing));
      }
    } catch (err) {
      print(err);
    }
  }

  submitForm(BuildContext context) async {
    emit(state.copyWith(submission: Submission.loading));
    if (CategoryController.text.isNotEmpty &&state.image != null) {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child(pickedFile!.path);
      final UploadTask uploadTask = storageRef.putData(state.image!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {
        emit(state.copyWith(image: null,submission: Submission.success));
        print(state.image.toString());
      });
      final String imageUrl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('storeCategories').add({
        'name': CategoryController.text,
        'imageUrl': imageUrl,
      });
      print("the download url is $imageUrl");
      CategoryController.clear();
      emit(state.copyWith(image: Uint8List(0),submission: Submission.success));
      print(state.image.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields and select an image'),
        ),
      );
    }
  }
}