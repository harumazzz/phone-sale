import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/request/payment_request.dart';
import '../model/response/payment_response.dart';
import '../service/service_locator.dart';

class PaymentApi extends Equatable {
  const PaymentApi();

  static const endpoint = '/payments';
  Future<List<PaymentResponse>> getPayments() async {
    final response = await ServiceLocator.get<Dio>().get(endpoint);
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return (apiResponse['data'] as List<dynamic>).map((e) => PaymentResponse.fromJson(e)).toList();
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to get payments');
        }
      } else {
        // Legacy format (direct list)
        return (response.data as List<dynamic>).map((e) => PaymentResponse.fromJson(e)).toList();
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<PaymentResponse> getPayment({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return PaymentResponse.fromJson(apiResponse['data']);
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Payment not found');
        }
      } else {
        // Legacy format (direct object)
        return PaymentResponse.fromJson(response.data);
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addPayment({required PaymentRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(endpoint, data: request.toJson());
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> editPayment({required int id, required PaymentRequest request}) async {
    final response = await ServiceLocator.get<Dio>().put('$endpoint/$id', data: request.toJson());
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> deletePayment({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
