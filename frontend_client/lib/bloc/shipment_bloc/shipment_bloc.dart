import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repository/shipment_repository.dart';

part 'shipment_event.dart';
part 'shipment_state.dart';

class ShipmentBloc extends Bloc<ShipmentEvent, ShipmentState> {
  ShipmentBloc({required this.shipmentRepository})
    : super(const ShipmentInitial()) {
    on<ShipmentEvent>(_onLoad);
  }

  final ShipmentRepository shipmentRepository;

  Future<void> _onLoad(ShipmentEvent event, Emitter<ShipmentState> emit) async {
    // TODO: implement event handler
  }
}
