using System.ComponentModel.DataAnnotations;

namespace backend.DTO.Response
{
    public class OrderResponse
    {
        [Required]
        public required int OrderId { get; set; }
        [Required]
        public required DateTime OrderDate { get; set; }
        [Required]
        public required decimal TotalPrice { get; set; }
        [Required]
        public required string CustomerId { get; set; }
    }

}
