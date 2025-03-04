using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class CustomerRequest
    {
        [Required]
        public required string FirstName { get; set; }
        [Required]
        public required string LastName { get; set; }
        [Required]
        public required string Email { get; set; }
        [Required]
        public required string Password { get; set; }
        [Required]
        public required string Address { get; set; }
        [Required]
        public required string PhoneNumber { get; set; }
    }

}
