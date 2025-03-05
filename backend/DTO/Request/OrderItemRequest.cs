using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class OrderItemRequest
    {
        [Required]
        public required int Quantity { get; set; }
        [Required]
        public required decimal Price { get; set; }
        [Required]
        public required int ProductId { get; set; }
        [Required]
        public required int OrderId { get; set; }
    }

}
