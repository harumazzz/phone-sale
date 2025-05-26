using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class ApplyDiscountRequest
    {
        [Required]
        public required string Code { get; set; }
        
        [Required]
        public required decimal CartTotal { get; set; }
        
        [Required]
        public required string CustomerId { get; set; }
    }
}
