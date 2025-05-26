using System.ComponentModel.DataAnnotations;
using backend.Models;

namespace backend.DTO.Request
{
    public class DiscountRequest
    {
        [Required]
        public required string Code { get; set; }
        
        [Required]
        public required string Description { get; set; }
        
        [Required]
        public DiscountType DiscountType { get; set; }
        
        [Required]
        public required decimal DiscountValue { get; set; }
        
        [Required]
        public required decimal MinOrderValue { get; set; }
        
        [Required]
        public bool IsActive { get; set; } = true;
        
        [Required]
        public required DateTime ValidFrom { get; set; }
        
        [Required]
        public required DateTime ValidTo { get; set; }
        
        public int? MaxUses { get; set; }
    }
}
