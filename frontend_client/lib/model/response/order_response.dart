import 'package:equatable/equatable.dart';

class OrderResponse extends Equatable {
  final int? orderId;
  final DateTime? orderDate;
  final int? totalPrice;
  final int? customerId;

  const OrderResponse({this.orderId, this.orderDate, this.totalPrice, this.customerId});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json['orderId'],
      orderDate: json['orderDate'] != null ? DateTime.parse(json['orderDate']) : null,
      totalPrice: json['totalPrice'],
      customerId: json['customerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderDate': orderDate?.toIso8601String(),
      'totalPrice': totalPrice,
      'customerId': customerId,
    };
  }

  @override
  List<Object?> get props => [orderId, orderDate, totalPrice, customerId];
}
