import 'package:equatable/equatable.dart';

final class ProductModel extends Equatable {
  final String documentId; // Updated
  final String? name;
  final String? price;
  final String? imageUrl;
  final String? category;
  final String? description;
  final bool isRecommended;
  final bool isPopular;

  ProductModel({
    required this.isRecommended,
    required this.isPopular,
    required this.description,
    required this.category,
    required this.documentId,
    this.price,
    this.name,
    this.imageUrl,
  });

  Map<String , dynamic> toMap(){
    return {
      'documentId': documentId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
      'isRecommended': isRecommended,
      'isPopular': isPopular,
    };
  }

  factory ProductModel.fromSnapshot(Map<String, dynamic> snap){
    return ProductModel(
      documentId: snap['documentId'],
      name: snap['name'],
      price: snap['price'],
      imageUrl: snap['imageUrl'],
      category: snap['category'],
      description: snap['description'],
      isRecommended: snap['isRecommended'],
      isPopular: snap['isPopular'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    documentId,
    name,
    price,
    imageUrl,
    category,
    description,
    isRecommended,
    isPopular,
  ];
}