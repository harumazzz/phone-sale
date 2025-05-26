import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

  Future<DiscountResponse> validateDiscount(String code, double cartTotal, String customerId) async {
    try {
      final response = await ServiceLocator.get<Dio>().post(
        '$endpoint/validate',
        data: {'code': code, 'cartTotal': cartTotal, 'customerId': customerId},
      );
      debugPrint('Discount validation response: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is Map && response.data.containsKey('success')) {
          final responseData = response.data as Map<String, dynamic>;
          final bool success = responseData['success'] as bool? ?? false;

          if (!success) {
            throw Exception(responseData['message'] ?? 'Validation failed');
          }

          // Handle the special validation response format
          if (responseData['data'] is Map<String, dynamic>) {
            final validationData = responseData['data'] as Map<String, dynamic>;
            final bool isValid = validationData['isValid'] as bool? ?? false;

            // Create a DiscountResponse from the validation data
            return DiscountResponse(
              discountId: validationData['discountId'] as int?,
              discountValue: validationData['discountAmount'] as double?,
              code: code, // Use the code that was sent in the request
              description: validationData['message'] as String?,
              isActive: isValid, // Use isValid as isActive
            );
          } else {
            // Fallback to standard deserialization
            return (responseData['data'] != null)
                ? DiscountResponse.fromJson(responseData['data'] as Map<String, dynamic>)
                : throw Exception('Invalid response data format');
          }
        } else {
          // Legacy format (direct object)
          return DiscountResponse.fromJson(response.data as Map<String, dynamic>);
        }
      } else {
        throw Exception('Failed to validate discount code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in validateDiscount: $e');
      throw Exception('Failed to validate discount code: $e');
    }
  }

  @override
  List<Object?> get props => [];
}
