using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class PaymentRequest
    {

        [Required, MaxLength(100)]
        public required string PaymentMethod { get; set; }

        [Required]
        public decimal Amount { get; set; }

        [Required]
        public required int CustomerId { get; set; }
    }
}
