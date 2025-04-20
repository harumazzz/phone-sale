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
      return (response.data as List<dynamic>)
          .map((e) => CustomerResponse.fromJson(e))
          .toList();
    } else {
      throw Exception(response.data);
    }
  }

  Future<CustomerResponse> getCustomer({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      return CustomerResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addCustomer({required CustomerRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(
      endpoint,
      data: request.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> editCustomer({
    required int id,
    required CustomerRequest request,
  }) async {
    final response = await ServiceLocator.get<Dio>().put(
      '$endpoint/$id',
      data: request.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> deleteCustomer({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
