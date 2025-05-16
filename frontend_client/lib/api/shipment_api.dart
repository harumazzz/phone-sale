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
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return (apiResponse['data'] as List<dynamic>).map((e) => ShipmentResponse.fromJson(e)).toList();
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to get shipments');
        }
      } else {
        // Legacy format (direct list)
        return (response.data as List<dynamic>).map((e) => ShipmentResponse.fromJson(e)).toList();
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<ShipmentResponse> getShipment({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return ShipmentResponse.fromJson(apiResponse['data']);
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Shipment not found');
        }
      } else {
        // Legacy format (direct object)
        return ShipmentResponse.fromJson(response.data);
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addShipment({required ShipmentRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(endpoint, data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to add shipment');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> editShipment({required int id, required ShipmentRequest request}) async {
    final response = await ServiceLocator.get<Dio>().put('$endpoint/$id', data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to update shipment');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> deleteShipment({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to delete shipment');
      }
    } else {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
