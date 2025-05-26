import 'package:equatable/equatable.dart';

import '../../model/response/discount_response.dart';

abstract class DiscountState extends Equatable {
  const DiscountState();

  @override
  List<Object?> get props => [];
}

class DiscountInitial extends DiscountState {}

class DiscountLoading extends DiscountState {}

class DiscountValidated extends DiscountState {
  const DiscountValidated(this.discount);
  final DiscountResponse discount;

  @override
  List<Object?> get props => [discount];
}

class DiscountError extends DiscountState {
  const DiscountError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class DiscountCleared extends DiscountState {}
