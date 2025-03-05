using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class OrderPaymentRequest
    {
        [Required]
        public required int OrderId { get; set; }
        [Required]
        public required int PaymentId { get; set; }
    }

}
