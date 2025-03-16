import 'package:equatable/equatable.dart';

import '../api/payment_api.dart';
import '../model/request/payment_request.dart';
import '../model/response/payment_response.dart';

class PaymentRepository extends Equatable {
  const PaymentRepository(this._api);

  final PaymentApi _api;

  Future<List<PaymentResponse>> getPayments() async {
    return await _api.getPayments();
  }

  Future<PaymentResponse> getPayment({required int id}) async {
    return await _api.getPayment(id: id);
  }

  Future<void> addPayment({required PaymentRequest request}) async {
    return await _api.addPayment(request: request);
  }

  Future<void> editPayment({
    required int id,
    required PaymentRequest request,
  }) async {
    return await _api.editPayment(id: id, request: request);
  }

  Future<void> deletePayment({required int id}) async {
    return await _api.deletePayment(id: id);
  }

  @override
  List<Object?> get props => [_api];
}
