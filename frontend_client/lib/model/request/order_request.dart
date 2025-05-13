import 'package:equatable/equatable.dart';

class OrderRequest extends Equatable {
  const OrderRequest({this.totalPrice, this.customerId});

  factory OrderRequest.fromJson(Map<String, dynamic> json) {
    return OrderRequest(totalPrice: json['totalPrice'], customerId: json['customerId']);
  }
  final double? totalPrice;
  final String? customerId;

  Map<String, dynamic> toJson() {
    return {'totalPrice': totalPrice, 'customerId': customerId};
  }

  @override
  List<Object?> get props => [totalPrice, customerId];
}
