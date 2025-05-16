class ApiResponse<T> {
  ApiResponse({required this.success, required this.message, this.data, this.error});
  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json.containsKey('data') && json['data'] != null ? fromJson(json['data']) : null,
      error: json['error'],
    );
  }

  factory ApiResponse.fromJsonList(Map<String, dynamic> json, T Function(List<dynamic>) fromJsonList) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json.containsKey('data') && json['data'] != null ? fromJsonList(json['data']) : null,
      error: json['error'],
    );
  }
  final bool success;
  final String message;
  final T? data;
  final String? error;
  static ApiResponse<List<T>> listFromJson<T>(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    final dataList = json['data'] as List?;
    final items = dataList?.map((item) => fromJson(item as Map<String, dynamic>)).toList();

    return ApiResponse<List<T>>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: items,
      error: json['error'],
    );
  }

  // For handling legacy API responses where the data is directly the list
  static ApiResponse<List<T>> fromDirectList<T>(List<dynamic> jsonList, T Function(Map<String, dynamic>) fromJson) {
    final items = jsonList.map((item) => fromJson(item as Map<String, dynamic>)).toList();

    return ApiResponse<List<T>>(success: true, message: 'Success', data: items);
  }
}
