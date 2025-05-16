namespace backend.Exceptions
{
    public class NotFoundException : Exception
    {
        public NotFoundException() : base("The requested resource was not found.") { }
        public NotFoundException(string message) : base(message) { }
        public NotFoundException(string message, Exception innerException) : base(message, innerException) { }
        public NotFoundException(string entityName, object entityId) 
            : base($"{entityName} with ID {entityId} was not found.") { }
    }

    public class BadRequestException : Exception
    {
        public BadRequestException() : base("The request was invalid.") { }
        public BadRequestException(string message) : base(message) { }
        public BadRequestException(string message, Exception innerException) : base(message, innerException) { }
    }

    public class ConflictException : Exception
    {
        public ConflictException() : base("A conflict occurred with the current state of the resource.") { }
        public ConflictException(string message) : base(message) { }
        public ConflictException(string message, Exception innerException) : base(message, innerException) { }
    }

    public class UnauthorizedException : Exception
    {
        public UnauthorizedException() : base("You are not authorized to access this resource.") { }
        public UnauthorizedException(string message) : base(message) { }
        public UnauthorizedException(string message, Exception innerException) : base(message, innerException) { }
    }

    public class ForbiddenException : Exception
    {
        public ForbiddenException() : base("You do not have permission to access this resource.") { }
        public ForbiddenException(string message) : base(message) { }
        public ForbiddenException(string message, Exception innerException) : base(message, innerException) { }
    }
}
