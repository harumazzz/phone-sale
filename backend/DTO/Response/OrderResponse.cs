using System.ComponentModel.DataAnnotations;
using backend.Models;

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
        [Required]
        public OrderStatus Status { get; set; }
    }

}
