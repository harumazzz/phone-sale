import 'package:equatable/equatable.dart';

class WishlistRequest extends Equatable {
  const WishlistRequest({this.customerId, this.productId});
  factory WishlistRequest.fromJson(Map<String, dynamic> json) {
    return WishlistRequest(
      customerId: json['customerId'],
      productId: json['productId'] as int?,
    );
  }
  final String? customerId;
  final int? productId;

  Map<String, dynamic> toJson() {
    return {'customerId': customerId, 'productId': productId};
  }

  @override
  List<Object?> get props => [customerId, productId];
}
