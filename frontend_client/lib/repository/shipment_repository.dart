import 'package:equatable/equatable.dart';

import '../api/shipment_api.dart';
import '../model/request/shipment_request.dart';
import '../model/response/shipment_response.dart';

class ShipmentRepository extends Equatable {
  const ShipmentRepository(this._api);

  final ShipmentApi _api;

  Future<List<ShipmentResponse>> getShipments() async {
    return await _api.getShipments();
  }

  Future<ShipmentResponse> getShipment({required int id}) async {
    return await _api.getShipment(id: id);
  }

  Future<void> addShipment({required ShipmentRequest request}) async {
    return await _api.addShipment(request: request);
  }

  Future<void> editShipment({
    required int id,
    required ShipmentRequest request,
  }) async {
    return await _api.editShipment(id: id, request: request);
  }

  Future<void> deleteShipment({required int id}) async {
    return await _api.deleteShipment(id: id);
  }

  @override
  List<Object?> get props => [_api];
}
