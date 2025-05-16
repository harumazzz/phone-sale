import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/request/login_request.dart';
import '../model/request/register_request.dart';
import '../model/response/customer_response.dart';
import '../service/service_locator.dart';

class AuthApi extends Equatable {
  const AuthApi();

  static const endpoint = '/auth';

  @override
  List<Object?> get props => [];
  Future<void> register({required RegisterRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post('$endpoint/register', data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>;
      if (apiResponse['success'] == true) {
        return;
      } else {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Registration failed');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<CustomerResponse> login({required LoginRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post('$endpoint/login', data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>;
      if (apiResponse['success'] == true && apiResponse['data'] != null) {
        return CustomerResponse.fromJson(apiResponse['data']);
      } else {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Login failed');
      }
    } else {
      throw Exception(response.data);
    }
  }
}
