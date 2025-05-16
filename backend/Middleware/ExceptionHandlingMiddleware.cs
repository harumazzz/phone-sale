using backend.DTO.Response;
using backend.Exceptions;
using Microsoft.EntityFrameworkCore;
using System.Net;
using System.Text.Json;

namespace backend.Middleware
{
    public class ExceptionHandlingMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ExceptionHandlingMiddleware> _logger;
        private readonly IWebHostEnvironment _env;

        public ExceptionHandlingMiddleware(
            RequestDelegate next,
            ILogger<ExceptionHandlingMiddleware> logger,
            IWebHostEnvironment env)
        {
            _next = next;
            _logger = logger;
            _env = env;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (Exception ex)
            {
                await HandleExceptionAsync(context, ex);
            }
        }

        private async Task HandleExceptionAsync(HttpContext context, Exception exception)
        {
            HttpStatusCode statusCode;
            string message;
            string? details = null;

            // Log the exception
            _logger.LogError(exception, "An unhandled exception occurred.");

            // Map exception type to appropriate HTTP status code
            switch (exception)
            {
                case NotFoundException _:
                    statusCode = HttpStatusCode.NotFound;
                    message = exception.Message;
                    break;

                case BadRequestException _:
                    statusCode = HttpStatusCode.BadRequest;
                    message = exception.Message;
                    break;

                case ConflictException _:
                    statusCode = HttpStatusCode.Conflict;
                    message = exception.Message;
                    break;

                case UnauthorizedException _:
                    statusCode = HttpStatusCode.Unauthorized;
                    message = exception.Message;
                    break;

                case ForbiddenException _:
                    statusCode = HttpStatusCode.Forbidden;
                    message = exception.Message;
                    break;

                case DbUpdateException _:
                    statusCode = HttpStatusCode.BadRequest;
                    message = "A database error occurred while saving data.";
                    details = _env.IsDevelopment() ? exception.Message : null;
                    break;
                default:
                    statusCode = HttpStatusCode.InternalServerError;
                    message = "An unexpected error occurred.";
                    details = _env.IsDevelopment() ? exception.Message : null;
                    break;
            }

            // Set the response status code
            context.Response.StatusCode = (int)statusCode;
            context.Response.ContentType = "application/json";

            // Create the response
            var response = ApiResponse<object>.Failure(message, details);

            // Serialize and write the response
            var json = JsonSerializer.Serialize(response);
            await context.Response.WriteAsync(json);
        }
    }

    // Extension method for easy registration in Program.cs
    public static class ExceptionHandlingMiddlewareExtensions
    {
        public static IApplicationBuilder UseExceptionHandlingMiddleware(this IApplicationBuilder app)
        {
            return app.UseMiddleware<ExceptionHandlingMiddleware>();
        }
    }
}
