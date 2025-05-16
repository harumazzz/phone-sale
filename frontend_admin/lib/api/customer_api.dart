import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/api_response.dart';
import '../model/request/customer_request.dart';
import '../model/response/customer_response.dart';
import '../service/service_locator.dart';

class CustomerApi extends Equatable {
  const CustomerApi();

  static const endpoint = '/customers';
  Future<List<CustomerResponse>> getCustomers() async {
    final response = await ServiceLocator.get<Dio>().get(endpoint);
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format with ApiResponse wrapper
        final apiResponse = ApiResponse.listFromJson(response.data as Map<String, dynamic>, CustomerResponse.fromJson);

        if (!apiResponse.success) {
          throw Exception(apiResponse.message);
        }

        return apiResponse.data ?? [];
      } else {
        // Legacy format (direct list)
        final apiResponse = ApiResponse.fromDirectList(response.data as List<dynamic>, CustomerResponse.fromJson);

        return apiResponse.data ?? [];
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<CustomerResponse> getCustomer({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format with ApiResponse wrapper
        final apiResponse = ApiResponse.fromJson(response.data as Map<String, dynamic>, CustomerResponse.fromJson);

        if (!apiResponse.success) {
          throw Exception(apiResponse.message);
        }

        if (apiResponse.data == null) {
          throw Exception("No customer data received");
        }

        return apiResponse.data!;
      } else {
        // Legacy format (direct object)
        return CustomerResponse.fromJson(response.data);
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addCustomer({required CustomerRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(endpoint, data: request.toJson());
    if (response.statusCode != 201) {
      throw Exception(response.data);
    }
  }

  Future<void> editCustomer({required int id, required CustomerRequest request}) async {
    final response = await ServiceLocator.get<Dio>().put('$endpoint/$id', data: request.toJson());
    if (response.statusCode != 204) {
      throw Exception(response.data);
    }
  }

  Future<void> deleteCustomer({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode != 204) {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
