using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class CartRequest
    {
        [Required]
        public required int CustomerId { get; set; }

        [Required]
        public required int ProductId { get; set; }

        [Required]
        public required int Quantity { get; set; }
    }

}
