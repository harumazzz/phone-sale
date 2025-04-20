import 'package:equatable/equatable.dart';

import 'response/cart_response.dart';
import 'response/product_response.dart';

class CartItemData extends Equatable {
  const CartItemData({required this.product, required this.cartInfo});
  final ProductResponse product;
  final CartResponse cartInfo;

  int get quantity => cartInfo.quantity;

  int get productId => product.productId!;

  @override
  List<Object?> get props => [product, cartInfo];
}
