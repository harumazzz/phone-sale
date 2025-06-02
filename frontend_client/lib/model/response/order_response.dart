import 'package:equatable/equatable.dart';
import '../../utils/currency_utils.dart';

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
  // Getter để chuyển đổi từ USD sang VND
  double? get totalPriceVnd => CurrencyUtils.usdToVnd(totalPrice);

  // Format tổng giá VND với dấu phẩy
  String get formattedTotalPriceVnd => CurrencyUtils.formatUsdToVnd(totalPrice);

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
