using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Response
{
    public class PaymentResponse
    {
        [Required]
        public required int PaymentId { get; set; }
        [Required]
        public required DateTime PaymentDate { get; set; }
        [Required]
        public required string PaymentMethod { get; set; }
        [Required]
        public required decimal Amount { get; set; }
        [Required]
        public required int CustomerId { get; set; }
    }
}
