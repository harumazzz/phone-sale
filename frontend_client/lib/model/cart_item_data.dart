import 'package:equatable/equatable.dart';

import 'response/cart_response.dart';
import 'response/product_response.dart';

class CartItemData extends Equatable {
  const CartItemData({required this.product, required this.cartInfo});
  final ProductResponse product;
  final CartResponse cartInfo;
  int get quantity => cartInfo.quantity;

  int get productId => product.productId!;

  // Getter để truy cập giá VND từ product
  double? get priceVnd => product.priceVnd;

  // Format giá VND
  String get formattedPriceVnd => product.formattedPriceVnd;

  // Tổng giá cho cart item này (giá VND × số lượng)
  double? get totalPriceVnd => priceVnd != null ? priceVnd! * quantity : null;

  // Format tổng giá VND
  String get formattedTotalPriceVnd {
    if (totalPriceVnd == null) {
      return '0 ₫';
    }
    return '${totalPriceVnd!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₫';
  }

  @override
  List<Object?> get props => [product, cartInfo];
}
