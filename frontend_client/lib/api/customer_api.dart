import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

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
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return (apiResponse['data'] as List<dynamic>).map((e) => CustomerResponse.fromJson(e)).toList();
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to get customers');
        }
      } else {
        // Legacy format (direct list)
        return (response.data as List<dynamic>).map((e) => CustomerResponse.fromJson(e)).toList();
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<CustomerResponse> getCustomer({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return CustomerResponse.fromJson(apiResponse['data']);
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Customer not found');
        }
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
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to add customer');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> editCustomer({required int id, required CustomerRequest request}) async {
    final response = await ServiceLocator.get<Dio>().put('$endpoint/$id', data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to update customer');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> deleteCustomer({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to delete customer');
      }
    } else {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
