import 'package:equatable/equatable.dart';

final class PaymentRequest extends Equatable {
  final String? paymentMethod;
  final int? amount;
  final int? customerId;

  const PaymentRequest({this.paymentMethod, this.amount, this.customerId});

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      paymentMethod: json['paymentMethod'] as String?,
      amount: json['amount'] as int?,
      customerId: json['customerId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'paymentMethod': paymentMethod, 'amount': amount, 'customerId': customerId};
  }

  @override
  List<Object?> get props => [paymentMethod, amount, customerId];
}
