import 'package:equatable/equatable.dart';

class CartResponse extends Equatable {
  const CartResponse({
    required this.cartId,
    required this.customerId,
    required this.productId,
    required this.quantity,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      cartId: json['cartId'] as int,
      customerId: json['customerId'] as String,
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
    );
  }

  final int cartId;

  final String customerId;

  final int productId;

  final int quantity;

  CartResponse copyWith({
    int? cartId,
    String? customerId,
    int? productId,
    int? quantity,
  }) {
    return CartResponse(
      cartId: cartId ?? this.cartId,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'customerId': customerId,
      'productId': productId,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [cartId, customerId, productId, quantity];
}
