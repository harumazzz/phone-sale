using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Response
{
    public class WishlistResponse
    {
        [Required]
        public required int WishlistId { get; set; }
        [Required]
        public required string CustomerId { get; set; }
        [Required]
        public required int ProductId { get; set; }
    }
}
