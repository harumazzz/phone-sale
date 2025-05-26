import 'package:equatable/equatable.dart';

import '../../model/discount_model.dart';

abstract class DiscountState extends Equatable {
  const DiscountState();

  @override
  List<Object?> get props => [];
}

class DiscountInitial extends DiscountState {}

class DiscountLoading extends DiscountState {}

class DiscountValidated extends DiscountState {
  const DiscountValidated(this.validation);
  final DiscountValidationModel validation;

  @override
  List<Object?> get props => [validation];
}

class DiscountError extends DiscountState {
  const DiscountError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class DiscountCleared extends DiscountState {}
