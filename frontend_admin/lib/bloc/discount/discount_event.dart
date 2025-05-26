part of 'discount_bloc.dart';

sealed class DiscountEvent extends Equatable {
  const DiscountEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiscountEvent extends DiscountEvent {
  const LoadDiscountEvent();
}

class AddDiscountEvent extends DiscountEvent {
  const AddDiscountEvent({required this.request});

  final DiscountRequest request;

  @override
  List<Object?> get props => [request];
}

class EditDiscountEvent extends DiscountEvent {
  const EditDiscountEvent({required this.id, required this.request});

  final int id;
  final DiscountRequest request;

  @override
  List<Object?> get props => [id, request];
}

class DeleteDiscountEvent extends DiscountEvent {
  const DeleteDiscountEvent({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}
