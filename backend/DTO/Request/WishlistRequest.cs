using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class WishlistRequest
    {
        [Required]
        public required string CustomerId { get; set; }
        [Required]
        public required int ProductId { get; set; }
    }
}
