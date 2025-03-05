using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class RegisterRequest
    {

        [Required, MaxLength(100)]
        public required string FirstName { get; set; }

        [Required, MaxLength(100)]
        public required string LastName { get; set; }

        [Required, EmailAddress, MaxLength(100)]
        public required string Email { get; set; }

        [Required, MaxLength(100)]
        public required string Password { get; set; }

        [Required, MaxLength(255)]
        public required string Address { get; set; }

        [Required, MaxLength(20)]
        public required string PhoneNumber { get; set; }
    }
}
