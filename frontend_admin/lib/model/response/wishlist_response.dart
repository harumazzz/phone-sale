import 'package:equatable/equatable.dart';

class WishlistResponse extends Equatable {
  const WishlistResponse({this.wishlistId, this.customerId, this.productId});
  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      wishlistId: json['wishlistId'] as int?,
      customerId: json['customerId'],
      productId: json['productId'] as int?,
    );
  }
  final int? wishlistId;
  final String? customerId;
  final int? productId;

  Map<String, dynamic> toJson() {
    return {
      'wishlistId': wishlistId,
      'customerId': customerId,
      'productId': productId,
    };
  }

  @override
  List<Object?> get props => [wishlistId, customerId, productId];
}
