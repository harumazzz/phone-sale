using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Response
{
    public class OrderPaymentResponse
    {
        [Required]
        public required int OrderId { get; set; }
        [Required]
        public required int PaymentId { get; set; }
    }

}
