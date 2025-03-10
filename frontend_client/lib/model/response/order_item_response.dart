import 'package:equatable/equatable.dart';

class OrderItemResponse extends Equatable {
  final int? orderItemId;
  final int? quantity;
  final int? price;
  final int? orderId;
  final int? productId;

  const OrderItemResponse({this.orderItemId, this.quantity, this.price, this.orderId, this.productId});

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) {
    return OrderItemResponse(
      orderItemId: json['orderItemId'],
      quantity: json['quantity'],
      price: json['price'],
      orderId: json['orderId'],
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderItemId': orderItemId,
      'quantity': quantity,
      'price': price,
      'orderId': orderId,
      'productId': productId,
    };
  }

  @override
  List<Object?> get props => [orderItemId, quantity, price, orderId, productId];
}
