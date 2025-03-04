using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Response
{
    public class CartResponse
    {
        [Required]
        public required int CartId { get; set; }
        [Required]
        public required int CustomerId { get; set; }
        [Required]
        public required int ProductId { get; set; }
        [Required]
        public required int Quantity { get; set; }
    }

}
