part of 'shipment_bloc.dart';

@immutable
sealed class ShipmentState extends Equatable {
  const ShipmentState();

  @override
  List<Object?> get props => [];
}

final class ShipmentInitial extends ShipmentState {
  const ShipmentInitial();
}
