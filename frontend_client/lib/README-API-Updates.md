# API Updates for New Response Format

This document explains the changes made to handle the new standardized API response format
implemented in the backend.

## Overview

The backend now uses a standardized response format with consistent structure:

```json
{
  "success": true/false,
  "message": "Operation successful/failed message",
  "data": { ... data payload ... },
  "error": "Error details if any"
}
```

## Client-side Changes

All API client classes have been updated to handle this new format. The changes follow these
patterns:

### For GET methods returning object:

```dart
if (response.statusCode == 200) {
  if (response.data is Map && response.data.containsKey('success')) {
    // New API response format
    final apiResponse = response.data as Map<String, dynamic>;
    if (apiResponse['success'] == true && apiResponse['data'] != null) {
      return ModelResponse.fromJson(apiResponse['data']);
    } else {
      throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Not found');
    }
  } else {
    // Legacy format (direct object)
    return ModelResponse.fromJson(response.data);
  }
} else {
  throw Exception(response.data);
}
```

### For GET methods returning lists:

```dart
if (response.statusCode == 200) {
  if (response.data is Map && response.data.containsKey('success')) {
    // New API response format
    final apiResponse = response.data as Map<String, dynamic>;
    if (apiResponse['success'] == true && apiResponse['data'] != null) {
      return (apiResponse['data'] as List<dynamic>)
          .map((e) => ModelResponse.fromJson(e))
          .toList();
    } else {
      throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to get items');
    }
  } else {
    // Legacy format (direct list)
    return (response.data as List<dynamic>)
        .map((e) => ModelResponse.fromJson(e))
        .toList();
  }
} else {
  throw Exception(response.data);
}
```

### For POST, PUT and DELETE methods:

```dart
if (response.statusCode == 200) {
  final apiResponse = response.data as Map<String, dynamic>?;
  if (apiResponse != null && apiResponse['success'] != true) {
    throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Operation failed');
  }
} else {
  throw Exception(response.data);
}
```

## Dio Interceptor Updates

The error interceptor has also been updated to properly extract error messages from the new response
format:

```dart
if (response.data is Map) {
  if (response.data.containsKey('success') && response.data['success'] == false) {
    // First check for error field, then fall back to message
    if (response.data.containsKey('error') && response.data['error'] != null) {
      return response.data['error'].toString();
    } else if (response.data.containsKey('message')) {
      return response.data['message'].toString();
    }
  }
}
```

## Files Updated

1. auth_api.dart
2. customer_api.dart
3. product_api.dart
4. category_api.dart
5. cart_api.dart
6. order_api.dart
7. wishlist_api.dart
8. shipment_api.dart
9. payment_api.dart
10. order_item_api.dart
11. dio_interceptor.dart

This update ensures the mobile client correctly handles the standardized API response format from
the backend.
