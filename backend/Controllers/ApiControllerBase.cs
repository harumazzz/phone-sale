using backend.DTO.Response;
using backend.Exceptions;
using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers
{
    public abstract class ApiControllerBase : ControllerBase
    {
        protected ActionResult<ApiResponse<T>> HandleSuccess<T>(T data, string? message = null)
        {
            return Ok(ApiResponse<T>.SuccessWithData(data, message));
        }

        protected ActionResult<ApiResponse<object>> HandleSuccess(string? message = null)
        {
            return Ok(ApiResponse<object>.SuccessWithoutData(message));
        }

        protected ActionResult HandleCreated<T>(string actionName, object routeValues, T data, string? message = null)
        {
            return CreatedAtAction(actionName, routeValues, ApiResponse<T>.SuccessWithData(data, message));
        }

        protected ActionResult<ApiResponse<T>> HandleNotFound<T>(string entityName, object entityId)
        {
            throw new NotFoundException(entityName, entityId);
        }

        protected ActionResult<ApiResponse<T>> HandleBadRequest<T>(string message)
        {
            throw new BadRequestException(message);
        }

        protected ActionResult<ApiResponse<T>> HandleConflict<T>(string message)
        {
            throw new ConflictException(message);
        }
    }
}
