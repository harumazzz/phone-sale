using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Response
{
    public class OrderItemResponse
    {
        [Required]
        public required int OrderItemId { get; set; }
        [Required]
        public required int Quantity { get; set; }
        [Required]
        public required decimal Price { get; set; }
        [Required]
        public required int OrderId { get; set; }
        [Required]
        public required int ProductId { get; set; }
    }

}
