import 'package:equatable/equatable.dart';

abstract class DiscountEvent extends Equatable {
  const DiscountEvent();

  @override
  List<Object?> get props => [];
}

class DiscountValidateEvent extends DiscountEvent {
  const DiscountValidateEvent({required this.code, required this.cartTotal, required this.customerId});
  final String code;
  final double cartTotal;
  final String customerId;

  @override
  List<Object?> get props => [code, cartTotal, customerId];
}

class DiscountClearEvent extends DiscountEvent {}
