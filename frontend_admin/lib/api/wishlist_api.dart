import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/request/wishlist_request.dart';
import '../model/response/wishlist_response.dart';
import '../service/service_locator.dart';

class WishlistApi extends Equatable {
  const WishlistApi();

  static const endpoint = '/wishlist';  Future<List<WishlistResponse>> getWishlists({required String customerId}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$customerId');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return (apiResponse['data'] as List<dynamic>).map((e) => WishlistResponse.fromJson(e)).toList();
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to get wishlists');
        }
      } else {
        // Legacy format (direct list)
        return (response.data as List<dynamic>).map((e) => WishlistResponse.fromJson(e)).toList();
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addWishlist({required WishlistRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(endpoint, data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to add to wishlist');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> editWishlist({required int id, required WishlistRequest request}) async {
    final response = await ServiceLocator.get<Dio>().put('$endpoint/$id', data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to update wishlist');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> deleteWishlist({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to delete wishlist');
      }
    } else {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
