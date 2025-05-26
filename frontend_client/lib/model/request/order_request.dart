import 'package:equatable/equatable.dart';

class OrderRequest extends Equatable {
  const OrderRequest({
    this.totalPrice,
    this.customerId,
    this.status,
    this.discountId,
    this.discountAmount,
    this.originalPrice,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) {
    return OrderRequest(
      totalPrice: json['totalPrice'],
      customerId: json['customerId'],
      status: json['status'],
      discountId: json['discountId'],
      discountAmount: json['discountAmount'],
      originalPrice: json['originalPrice'],
    );
  }

  final double? totalPrice;
  final String? customerId;
  final int? status;
  final int? discountId;
  final double? discountAmount;
  final double? originalPrice;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'totalPrice': totalPrice, 'customerId': customerId, 'status': status};

    if (discountId != null) {
      data['discountId'] = discountId;
    }
    if (discountAmount != null) {
      data['discountAmount'] = discountAmount;
    }
    if (originalPrice != null) {
      data['originalPrice'] = originalPrice;
    }

    return data;
  }

  @override
  List<Object?> get props => [totalPrice, customerId, status, discountId, discountAmount, originalPrice];
}
