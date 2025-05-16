using System.ComponentModel.DataAnnotations;
using backend.Models;

namespace backend.DTO.Request
{
    public class OrderRequest
    {
        [Required]
        public required decimal TotalPrice { get; set; }
        [Required]
        public required string CustomerId { get; set; }
        
        // Optional status - defaults to Pending if not provided
        public OrderStatus? Status { get; set; }
    }

}
