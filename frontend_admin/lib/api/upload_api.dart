import 'dart:typed_data';
import 'package:dio/dio.dart';

import '../service/service_locator.dart';

class UploadApi {
  const UploadApi();

  static const String endpoint = '/upload';

  Future<String> uploadImage({required Uint8List fileBytes, required String fileName}) async {
    try {
      final formData = FormData.fromMap({'file': MultipartFile.fromBytes(fileBytes, filename: fileName)});

      final response = await ServiceLocator.get<Dio>().post('$endpoint/image', data: formData);

      if (response.statusCode == 200) {
        final data = response.data;
        return data['url'] as String;
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
