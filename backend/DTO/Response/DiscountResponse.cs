using backend.Models;

namespace backend.DTO.Response
{
    public class DiscountResponse
    {
        public int DiscountId { get; set; }
        
        public required string Code { get; set; }
        
        public required string Description { get; set; }
        
        public DiscountType DiscountType { get; set; }
        
        public decimal DiscountValue { get; set; }
        
        public decimal MinOrderValue { get; set; }
        
        public bool IsActive { get; set; }
        
        public DateTime ValidFrom { get; set; }
        
        public DateTime ValidTo { get; set; }
        
        public int? MaxUses { get; set; }
        
        public int CurrentUses { get; set; }
    }
}
