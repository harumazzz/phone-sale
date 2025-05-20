import 'package:equatable/equatable.dart';

import '../api/wishlist_api.dart';
import '../model/request/wishlist_request.dart';
import '../model/response/wishlist_response.dart';

class WishlistRepository extends Equatable {
  const WishlistRepository(this._api);

  final WishlistApi _api;

  Future<List<WishlistResponse>> getWishlists({required String customerId}) async {
    try {
      return await _api.getWishlists(customerId: customerId);
    } catch (e) {
      throw Exception('Failed to get wishlist: ${e.toString()}');
    }
  }

  Future<void> addWishlist({required WishlistRequest request}) async {
    try {
      return await _api.addWishlist(request: request);
    } catch (e) {
      throw Exception('Failed to add to wishlist: ${e.toString()}');
    }
  }

  Future<void> editWishlist({required int id, required WishlistRequest request}) async {
    try {
      return await _api.editWishlist(id: id, request: request);
    } catch (e) {
      throw Exception('Failed to update wishlist: ${e.toString()}');
    }
  }

  Future<void> deleteWishlist({required int id}) async {
    try {
      return await _api.deleteWishlist(id: id);
    } catch (e) {
      throw Exception('Failed to remove from wishlist: ${e.toString()}');
    }
  }

  @override
  List<Object?> get props => [_api];
}
