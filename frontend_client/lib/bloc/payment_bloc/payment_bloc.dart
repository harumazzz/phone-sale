import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repository/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc({required this.paymentRepository})
    : super(const PaymentInitial()) {
    on<PaymentEvent>(_onLoad);
  }

  final PaymentRepository paymentRepository;

  Future<void> _onLoad(PaymentEvent event, Emitter<PaymentState> emit) async {
    // TODO: implement event handler
  }
}
