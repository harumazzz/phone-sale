namespace backend.DTO.Response
{
    public class DiscountValidationResponse
    {
        public bool IsValid { get; set; }
        
        public string? Message { get; set; }
        
        public decimal? DiscountAmount { get; set; }
        
        public int? DiscountId { get; set; }
        
        public decimal? FinalPrice { get; set; }
    }
}
