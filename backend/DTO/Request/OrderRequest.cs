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
        
        // Discount related fields
        public int? DiscountId { get; set; }
        
        public decimal DiscountAmount { get; set; } = 0;
        
        public decimal OriginalPrice { get; set; }
    }

}
