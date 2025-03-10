import 'package:equatable/equatable.dart';

class WishlistResponse extends Equatable {
  final int? customerId;
  final int? productId;

  const WishlistResponse({this.customerId, this.productId});

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(customerId: json['customerId'] as int?, productId: json['productId'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {'customerId': customerId, 'productId': productId};
  }

  @override
  List<Object?> get props => [customerId, productId];
}
