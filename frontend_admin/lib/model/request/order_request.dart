import 'package:equatable/equatable.dart';

class OrderRequest extends Equatable {
  const OrderRequest({this.totalPrice, this.customerId, this.status});

  factory OrderRequest.fromJson(Map<String, dynamic> json) {
    return OrderRequest(totalPrice: json['totalPrice'], customerId: json['customerId'], status: json['status']);
  }
  final double? totalPrice;
  final String? customerId;
  final int? status;

  Map<String, dynamic> toJson() {
    return {'totalPrice': totalPrice, 'customerId': customerId, 'status': status};
  }

  @override
  List<Object?> get props => [totalPrice, customerId, status];
}
