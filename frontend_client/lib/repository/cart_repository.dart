import 'package:equatable/equatable.dart';

import '../api/cart_api.dart';
import '../model/request/cart_request.dart';
import '../model/response/cart_response.dart';

class CartRepository extends Equatable {
  const CartRepository(this._api);

  final CartApi _api;

  Future<List<CartResponse>> getAllCart({required String customerId}) async {
    return await _api.getAllCart(customerId: customerId);
  }

  Future<void> addCart({required CartRequest request}) async {
    return await _api.addCart(request: request);
  }

  Future<void> editCart({
    required int cartId,
    required CartRequest request,
  }) async {
    return await _api.editCart(cartId: cartId, request: request);
  }

  Future<void> deleteCart({required int cartId}) async {
    return await _api.deleteCart(cartId: cartId);
  }

  @override
  List<Object?> get props => [_api];
}
