import 'package:equatable/equatable.dart';

class CartRequest extends Equatable {
  const CartRequest({
    required this.customerId,
    required this.productId,
    required this.quantity,
  });

  factory CartRequest.fromJson(Map<String, dynamic> json) {
    return CartRequest(
      customerId: json['customerId'] as String,
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
    );
  }

  final String customerId;

  final int productId;

  final int quantity;

  CartRequest copyWith({String? customerId, int? productId, int? quantity}) {
    return CartRequest(
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'productId': productId,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [customerId, productId, quantity];
}
