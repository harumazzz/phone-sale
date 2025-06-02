import 'package:equatable/equatable.dart';
import '../../utils/currency_utils.dart';

class OrderItemResponse extends Equatable {
  const OrderItemResponse({this.orderItemId, this.quantity, this.price, this.orderId, this.productId});
  factory OrderItemResponse.fromJson(Map<String, dynamic> json) {
    return OrderItemResponse(
      orderItemId: json['orderItemId'],
      quantity: json['quantity'],
      price: json['price']?.toDouble(),
      orderId: json['orderId'],
      productId: json['productId'],
    );
  }
  final int? orderItemId;
  final int? quantity;
  final double? price;
  final int? orderId;
  final int? productId;
  // Getter để chuyển đổi từ USD sang VND
  double? get priceVnd => CurrencyUtils.usdToVnd(price);

  // Format giá VND với dấu phẩy
  String get formattedPriceVnd => CurrencyUtils.formatUsdToVnd(price);

  // Tổng giá cho item này (giá × số lượng)
  double? get totalPriceVnd => priceVnd != null && quantity != null ? priceVnd! * quantity! : null;

  // Format tổng giá VND với dấu phẩy
  String get formattedTotalPriceVnd => CurrencyUtils.formatVnd(totalPriceVnd);

  Map<String, dynamic> toJson() {
    return {
      'orderItemId': orderItemId,
      'quantity': quantity,
      'price': price,
      'orderId': orderId,
      'productId': productId,
    };
  }

  @override
  List<Object?> get props => [orderItemId, quantity, price, orderId, productId];
}
