
import 'package:flutter/foundation.dart';

class StoreState {
  final List<Uint8List>? image;

  StoreState({this.image});

  StoreState copyWith({List<Uint8List>? image}) {
    return StoreState(
      image: image ?? this.image,
    );
  }
}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final List<StoreItem> items;

  final List<StoreItem> filteredItems;

  StoreLoaded({required this.filteredItems, required this.items});
}


class StoreError extends StoreState {}

//Store Model
class StoreItem {
  final String documentId; // Updated
  String name;
  num? price;
  List <String> imageUrl;
  String? category = "All";
  int? Quantity;
  bool isRecommended;
  bool isPopular;

  StoreItem({
    required this.Quantity,
    required this.category,
    required this.documentId,
    required this.price,
    required this.name,
    required this.imageUrl,
    this.isRecommended = false,
    this.isPopular = false,
  });
}