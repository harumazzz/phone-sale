import 'package:equatable/equatable.dart';

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class OrderResponse extends Equatable {
  const OrderResponse({this.orderId, this.orderDate, this.totalPrice, this.customerId, this.status});
  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json['orderId'],
      orderDate: json['orderDate'] != null ? DateTime.parse(json['orderDate']) : null,
      totalPrice: json['totalPrice'],
      customerId: json['customerId'],
      status: json['status'] != null ? OrderStatus.values[json['status']] : OrderStatus.pending,
    );
  }
  final int? orderId;
  final DateTime? orderDate;
  final double? totalPrice;
  final String? customerId;
  final OrderStatus? status;

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderDate': orderDate?.toIso8601String(),
      'totalPrice': totalPrice,
      'customerId': customerId,
      'status': status?.index,
    };
  }

  @override
  List<Object?> get props => [orderId, orderDate, totalPrice, customerId, status];
}
