import 'package:equatable/equatable.dart';

class ProductResponse extends Equatable {
  const ProductResponse({
    this.productId,
    this.model,
    this.description,
    this.price,
    this.stock,
    this.categoryId,
    this.productLink,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      productId: json['productId'] as int?,
      model: json['model'] as String?,
      description: json['description'] as String?,
      price: json['price'] as double?,
      stock: json['stock'] as int?,
      categoryId: json['categoryId'] as int?,
      productLink: json['productLink'] as String?,
    );
  }
  final int? productId;
  final String? model;
  final String? description;
  final double? price;
  final int? stock;
  final int? categoryId;
  final String? productLink;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'model': model,
      'description': description,
      'price': price,
      'stock': stock,
      'categoryId': categoryId,
      'productLink': productLink,
    };
  }

  @override
  List<Object?> get props => [
    productId,
    model,
    description,
    price,
    stock,
    categoryId,
    productLink,
  ];
}
