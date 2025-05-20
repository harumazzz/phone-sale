import 'package:equatable/equatable.dart';

import '../api/wishlist_api.dart';
import '../model/request/wishlist_request.dart';
import '../model/response/wishlist_response.dart';

class WishlistRepository extends Equatable {
  const WishlistRepository(this._api);

  final WishlistApi _api;

  Future<List<WishlistResponse>> getWishlists({required String customerId}) async {
    return await _api.getWishlists(customerId: customerId);
  }

  Future<void> addWishlist({required WishlistRequest request}) async {
    return await _api.addWishlist(request: request);
  }

  Future<void> editWishlist({required int id, required WishlistRequest request}) async {
    return await _api.editWishlist(id: id, request: request);
  }

  Future<void> deleteWishlist({required int id}) async {
    return await _api.deleteWishlist(id: id);
  }

  @override
  List<Object?> get props => [_api];
}
