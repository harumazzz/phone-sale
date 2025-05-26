using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class ForgotPasswordRequest
    {
        [Required, EmailAddress]
        public required string Email { get; set; }
    }
}
