# Phone Sale Backend API - Exception Handling and Standardized Responses

This document describes the implementation of exception handling and standardized response formats
in the backend.

## API Response Format

All API responses now follow a standard format:

```json
{
  "success": true|false,
  "data": { /* response data object or array */ },
  "message": "A descriptive message about the operation",
  "error": "Optional error details (only present when success is false)"
}
```

## Exception Handling

Exception handling has been implemented with a middleware that catches all exceptions and returns
appropriate HTTP status codes with standardized error responses.

### Custom Exception Types

-   `NotFoundException`: When a requested resource is not found (404)
-   `BadRequestException`: When the request is invalid (400)
-   `ConflictException`: When there is a conflict with the current state (409)
-   `UnauthorizedException`: When authentication fails (401)
-   `ForbiddenException`: When user lacks permission (403)

## Response Helper Methods

The `ApiControllerBase` provides helper methods for controllers to standardize responses:

-   `HandleSuccess<T>(T data, string message)`: For successful responses with data
-   `HandleSuccess(string message)`: For successful responses without data
-   `HandleCreated<T>(string actionName, object routeValues, T data, string message)`: For resource
    creation responses
-   `HandleNotFound<T>(string entityName, object entityId)`: For not found errors
-   `HandleBadRequest<T>(string message)`: For bad request errors
-   `HandleConflict<T>(string message)`: For conflict errors

## Implementation Details

1. All controllers now inherit from `ApiControllerBase`
2. Exception handling middleware catches and processes all exceptions
3. Custom exceptions provide meaningful error messages
4. Standardized responses across all controllers

## Usage Example

Controllers now handle errors and responses in a standardized way:

```csharp
[HttpGet("{id}")]
public async Task<ActionResult<ApiResponse<Product>>> GetProduct(int id)
{
    try
    {
        var product = await _context.Products.FindAsync(id);
        if (product == null)
        {
            return HandleNotFound<Product>("Product", id);
        }
        return HandleSuccess(product, $"Product with ID {id} retrieved successfully");
    }
    catch (Exception ex)
    {
        throw new Exception($"Error retrieving product with ID {id}", ex);
    }
}
```

## Benefits

1. Consistent error handling across the API
2. Clear error messages for frontend developers
3. Standard response format simplifies frontend integration
4. Improved maintainability and debugging
