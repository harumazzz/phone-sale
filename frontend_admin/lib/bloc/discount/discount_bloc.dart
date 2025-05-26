import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/request/discount_request.dart';
import '../../model/response/discount_response.dart';
import '../../repository/discount_repository.dart';

part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  DiscountBloc({required this.discountRepository}) : super(DiscountInitial()) {
    on<LoadDiscountEvent>(_onLoadDiscounts);
    on<AddDiscountEvent>(_onAddDiscount);
    on<EditDiscountEvent>(_onEditDiscount);
    on<DeleteDiscountEvent>(_onDeleteDiscount);
  }

  final DiscountRepository discountRepository;

  Future<void> _onLoadDiscounts(LoadDiscountEvent event, Emitter<DiscountState> emit) async {
    emit(DiscountLoading());
    try {
      final discounts = await discountRepository.getDiscounts();
      emit(DiscountLoaded(discounts: discounts));
    } catch (e) {
      emit(DiscountError(message: e.toString()));
    }
  }

  Future<void> _onAddDiscount(AddDiscountEvent event, Emitter<DiscountState> emit) async {
    try {
      await discountRepository.addDiscount(event.request);
      add(const LoadDiscountEvent());
    } catch (e) {
      emit(DiscountError(message: e.toString()));
    }
  }

  Future<void> _onEditDiscount(EditDiscountEvent event, Emitter<DiscountState> emit) async {
    try {
      await discountRepository.updateDiscount(event.id, event.request);
      add(const LoadDiscountEvent());
    } catch (e) {
      emit(DiscountError(message: e.toString()));
    }
  }

  Future<void> _onDeleteDiscount(DeleteDiscountEvent event, Emitter<DiscountState> emit) async {
    try {
      await discountRepository.deleteDiscount(event.id);
      add(const LoadDiscountEvent());
    } catch (e) {
      emit(DiscountError(message: e.toString()));
    }
  }
}
