
import 'package:flutter/foundation.dart';

class CategoriesState {
  final Uint8List? image;

  CategoriesState({this.image});

  CategoriesState copyWith({Uint8List? image}) {
    return CategoriesState(
      image: image ?? this.image,
    );
  }
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<CategoriesItem> items;

  CategoriesLoaded({required this.items});

}

class CategoriesNamesLoaded extends CategoriesState {
  final List<String> items;

  CategoriesNamesLoaded({required this.items});
}

class CategoriesError extends CategoriesState {}

//Categories Model
class CategoriesItem {
  final String imageUrl;
  String category;

  final String documentId;

  CategoriesItem({
    required this.documentId,
    required this.category,
    required this.imageUrl,
  });}