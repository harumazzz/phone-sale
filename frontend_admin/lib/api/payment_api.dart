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
      return (response.data as List<dynamic>).map((e) => PaymentResponse.fromJson(e)).toList();
    } else {
      throw Exception(response.data);
    }
  }

  Future<PaymentResponse> getPayment({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      return PaymentResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addPayment({required PaymentRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(endpoint, data: request.toJson());
    if (response.statusCode != 201) {
      throw Exception(response.data);
    }
  }

  Future<void> editPayment({required int id, required PaymentRequest request}) async {
    final response = await ServiceLocator.get<Dio>().put('$endpoint/$id', data: request.toJson());
    if (response.statusCode != 204) {
      throw Exception(response.data);
    }
  }

  Future<void> deletePayment({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode != 204) {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
