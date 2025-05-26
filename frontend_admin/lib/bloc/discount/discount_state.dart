part of 'discount_bloc.dart';

sealed class DiscountState extends Equatable {
  const DiscountState();

  @override
  List<Object> get props => [];
}

final class DiscountInitial extends DiscountState {}

final class DiscountLoading extends DiscountState {}

final class DiscountLoaded extends DiscountState {
  const DiscountLoaded({required this.discounts});

  final List<DiscountResponse> discounts;

  @override
  List<Object> get props => [discounts];
}

final class DiscountError extends DiscountState {
  const DiscountError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
