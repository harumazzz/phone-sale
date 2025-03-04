using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Response
{
    public class CustomerResponse
    {
        [Required]
        public required int CustomerId { get; set; }
        [Required]
        public required string FirstName { get; set; } = string.Empty;
        [Required]
        public required string LastName { get; set; } = string.Empty;
        [Required]
        public required string Email { get; set; } = string.Empty;
        [Required]
        public required string Address { get; set; } = string.Empty;
        [Required]
        public required string PhoneNumber { get; set; } = string.Empty;
    }

}
