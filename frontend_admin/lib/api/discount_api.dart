import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/api_response.dart';
import '../model/request/discount_request.dart';
import '../model/response/discount_response.dart';
import '../service/service_locator.dart';

class DiscountApi extends Equatable {
  const DiscountApi();

  static const endpoint = '/discounts';

  Future<List<DiscountResponse>> getDiscounts() async {
    final response = await ServiceLocator.get<Dio>().get(endpoint);
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format with ApiResponse wrapper
        final apiResponse = ApiResponse.listFromJson(response.data as Map<String, dynamic>, DiscountResponse.fromJson);

        if (!apiResponse.success) {
          throw Exception(apiResponse.message);
        }

        return apiResponse.data ?? [];
      } else {
        // Legacy format (direct list)
        final apiResponse = ApiResponse.fromDirectList(response.data as List<dynamic>, DiscountResponse.fromJson);

        return apiResponse.data ?? [];
      }
    } else {
      throw Exception('Failed to fetch discounts');
    }
  }

  Future<DiscountResponse> getDiscountById(int id) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format with ApiResponse wrapper
        final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>, DiscountResponse.fromJson);

        if (!apiResponse.success) {
          throw Exception(apiResponse.message);
        }

        return apiResponse.data!;
      } else {
        // Legacy format (direct object)
        return DiscountResponse.fromJson(response.data as Map<String, dynamic>);
      }
    } else {
      throw Exception('Failed to fetch discount');
    }
  }

  Future<DiscountResponse> addDiscount(DiscountRequest request) async {
    final response = await ServiceLocator.get<Dio>().post(endpoint, data: request.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format with ApiResponse wrapper
        final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>, DiscountResponse.fromJson);

        if (!apiResponse.success) {
          throw Exception(apiResponse.message);
        }

        return apiResponse.data!;
      } else {
        // Legacy format (direct object)
        return DiscountResponse.fromJson(response.data as Map<String, dynamic>);
      }
    } else {
      throw Exception('Failed to add discount');
    }
  }

  Future<DiscountResponse> updateDiscount(int id, DiscountRequest request) async {
    final response = await ServiceLocator.get<Dio>().put('$endpoint/$id', data: request.toJson());
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format with ApiResponse wrapper
        final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>, DiscountResponse.fromJson);

        if (!apiResponse.success) {
          throw Exception(apiResponse.message);
        }

        return apiResponse.data!;
      } else {
        // Legacy format (direct object)
        return DiscountResponse.fromJson(response.data as Map<String, dynamic>);
      }
    } else {
      throw Exception('Failed to update discount');
    }
  }

  Future<void> deleteDiscount(int id) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete discount');
    }
  }

  @override
  List<Object?> get props => [];
}
