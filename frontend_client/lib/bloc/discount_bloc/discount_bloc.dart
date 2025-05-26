import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/discount_repository.dart';
import 'discount_event.dart';
import 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  DiscountBloc({required this.discountRepository}) : super(DiscountInitial()) {
    on<DiscountValidateEvent>(_onValidate);
    on<DiscountClearEvent>(_onClear);
  }
  final DiscountRepository discountRepository;
  Future<void> _onValidate(DiscountValidateEvent event, Emitter<DiscountState> emit) async {
    emit(DiscountLoading());
    try {
      final discount = await discountRepository.validateDiscount(
        code: event.code,
        cartTotal: event.cartTotal,
        customerId: event.customerId,
      );
      emit(DiscountValidated(discount));
    } catch (e) {
      emit(DiscountError(e.toString()));
    }
  }

  Future<void> _onClear(DiscountClearEvent event, Emitter<DiscountState> emit) async {
    emit(DiscountCleared());
    emit(DiscountInitial());
  }
}
