using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Request
{
    public class ProductRequest
    {
        [Required, MaxLength(100)]
        public required string Model { get; set; }

        [Required, MaxLength(255)]
        public required string ProductLink { get; set; }

        [MaxLength(255)]
        public string? Description { get; set; }

        [Required]
        public required decimal Price { get; set; }

        [Required]
        public required int Stock { get; set; }

        [Required]
        public required int CategoryId { get; set; }
    }
}
