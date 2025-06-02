import 'package:equatable/equatable.dart';

class OrderItemRequest extends Equatable {
  const OrderItemRequest({this.quantity, this.price, this.productId, this.orderId});
  factory OrderItemRequest.fromJson(Map<String, dynamic> json) {
    return OrderItemRequest(
      quantity: json['quantity'],
      price: json['price']?.toDouble(),
      productId: json['productId'],
      orderId: json['orderId'],
    );
  }
  final int? quantity;
  final double? price;
  final int? productId;
  final int? orderId;

  Map<String, dynamic> toJson() {
    return {'quantity': quantity, 'price': price, 'productId': productId, 'orderId': orderId};
  }

  @override
  List<Object?> get props => [quantity, price, productId, orderId];
}
