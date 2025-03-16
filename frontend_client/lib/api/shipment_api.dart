import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/request/shipment_request.dart';
import '../model/response/shipment_response.dart';
import '../service/service_locator.dart';

class ShipmentApi extends Equatable {
  const ShipmentApi();

  static const endpoint = '/shipments';

  Future<List<ShipmentResponse>> getShipments() async {
    final response = await ServiceLocator.get<Dio>().get(endpoint);
    if (response.statusCode == 200) {
      return (response.data as List<dynamic>)
          .map((e) => ShipmentResponse.fromJson(e))
          .toList();
    } else {
      throw Exception(response.data);
    }
  }

  Future<ShipmentResponse> getShipment({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      return ShipmentResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addShipment({required ShipmentRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(
      endpoint,
      data: request.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> editShipment({
    required int id,
    required ShipmentRequest request,
  }) async {
    final response = await ServiceLocator.get<Dio>().put(
      '$endpoint/$id',
      data: request.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> deleteShipment({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
