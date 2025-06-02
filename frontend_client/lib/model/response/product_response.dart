import 'package:equatable/equatable.dart';
import '../../utils/currency_utils.dart';

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
  // Getter để chuyển đổi từ USD sang VND
  double? get priceVnd => CurrencyUtils.usdToVnd(price);

  // Format giá VND với dấu phẩy
  String get formattedPriceVnd => CurrencyUtils.formatUsdToVnd(price);

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
  List<Object?> get props => [productId, model, description, price, stock, categoryId, productLink];
}
