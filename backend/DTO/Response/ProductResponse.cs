using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Response
{
    public class ProductResponse
    {
        [Required]
        public required int ProductId { get; set; }
        [Required]
        public required string Model { get; set; }
        [Required]
        public required string ProductLink { get; set; }
        [Required]
        public string? Description { get; set; }
        [Required]
        public required decimal Price { get; set; }
        [Required]
        public required int Stock { get; set; }
        [Required]
        public required int CategoryId { get; set; }
    }
}
