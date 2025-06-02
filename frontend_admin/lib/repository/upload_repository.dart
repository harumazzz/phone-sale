import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import '../api/upload_api.dart';

class UploadRepository extends Equatable {
  const UploadRepository(this._api);

  final UploadApi _api;

  Future<String> uploadImage({required Uint8List fileBytes, required String fileName}) async {
    return await _api.uploadImage(fileBytes: fileBytes, fileName: fileName);
  }

  @override
  List<Object?> get props => [_api];
}
