import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repository/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({required this.orderRepository}) : super(const OrderInitial()) {
    on<OrderEvent>(_onLoad);
  }

  final OrderRepository orderRepository;

  Future<void> _onLoad(OrderEvent event, Emitter<OrderState> emit) async {
    // TODO: implement event handler
  }
}
