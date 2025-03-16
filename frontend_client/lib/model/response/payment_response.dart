import 'package:equatable/equatable.dart';

class PaymentResponse extends Equatable {
  const PaymentResponse({
    this.paymentId,
    this.paymentDate,
    this.paymentMethod,
    this.amount,
    this.customerId,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      paymentId: json['paymentId'],
      paymentDate:
          json['paymentDate'] != null
              ? DateTime.parse(json['paymentDate'])
              : null,
      paymentMethod: json['paymentMethod'],
      amount: json['amount'],
      customerId: json['customerId'],
    );
  }
  final int? paymentId;
  final DateTime? paymentDate;
  final String? paymentMethod;
  final int? amount;
  final int? customerId;

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'paymentDate': paymentDate?.toIso8601String(),
      'paymentMethod': paymentMethod,
      'amount': amount,
      'customerId': customerId,
    };
  }

  @override
  List<Object?> get props => [
    paymentId,
    paymentDate,
    paymentMethod,
    amount,
    customerId,
  ];
}
