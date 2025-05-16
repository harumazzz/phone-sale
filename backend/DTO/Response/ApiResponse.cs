using System.Text.Json.Serialization;

namespace backend.DTO.Response
{
    public class ApiResponse<T>
    {
        public bool Success { get; set; }
        public T? Data { get; set; }
        public string? Message { get; set; }
        public string? Error { get; set; }

        // Success response with data
        public static ApiResponse<T> SuccessWithData(T data, string? message = null)
        {
            return new ApiResponse<T>
            {
                Success = true,
                Data = data,
                Message = message ?? "Operation completed successfully",
                Error = null
            };
        }

        // Success response without data
        public static ApiResponse<T> SuccessWithoutData(string? message = null)
        {
            return new ApiResponse<T>
            {
                Success = true,
                Data = default,
                Message = message ?? "Operation completed successfully",
                Error = null
            };
        }

        // Error response with message and optional error details
        public static ApiResponse<T> Failure(string message, string? error = null)
        {
            return new ApiResponse<T>
            {
                Success = false,
                Data = default,
                Message = message,
                Error = error
            };
        }
    }
}
